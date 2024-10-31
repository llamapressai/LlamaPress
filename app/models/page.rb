class Page < ApplicationRecord
  include Rails.application.routes.url_helpers
  include ApplicationHelper
  extend FriendlyId

  belongs_to :site
  belongs_to :organization
  
  has_many :page_histories, dependent: :destroy
  has_many :posts, dependent: :nullify

  friendly_id :slug, use: :slugged

  before_validation :ensure_site, on: :create
  
  #TODO: Eventually we'll want it to be unique just for the individual sites -- validates :slug, uniqueness: { scope: :site_id, message: "must be unique within the site" }
  validates :slug, uniqueness: { message: "must be unique across all sites" }

  before_validation :make_unique_slug, on: :create

  after_initialize :set_default_html_content, if: :new_record?
  before_save :pre_save_processing, if: :content_changed?

  def render_content
    content = self.content
    content = render_snippets(content)
    content = render_llama_contenteditable_tags(content)
    return content
  end

  def render_snippets(content)
    # a snippet syntax looks like {{snippet_name:header}} or {{snippet_name:footer}}, or {{snippet_id:1}}
    # for each {{snippet_name:name}} or {{snippet_id:id}} in the content, see if there is a matching snippet
    # if so, replace the {{snippet_name:name}} or {{snippet_id:id}} with the snippet content

    # This works for both snippet id, and by snippet name
    # if the snippet name is not found, then don't replace it
    # if the snippet id is not found, then don't replace it
    # if the snippet id is found, then replace it
    # if the snippet name is found, then replace it
    content.gsub!(/\{\{snippet_id:(.*?)\}\}/) do |match|
      snippet_identifier = $1
      snippet = Snippet.find_by(id: snippet_identifier)
      if snippet.present?
        # Parse the snippet content as a fragment
        fragment = Nokogiri::HTML::DocumentFragment.parse(snippet.content)
        
        # Add the data-llama-snippet-id attribute to each node in the fragment. This snippet id is used to prevent the user from overwriting the snippet when they edit the page, and to allow the user to edit the snippet from any page it's referenced.
        fragment.css('*').each do |node| #we inject this data-llama-snippet-id attribute to each node in the fragment so we know it's a global snippet. 
          node.set_attribute('data-llama-snippet-id', snippet_identifier)
        end
        
        # Convert the fragment back to HTML
        fragment.to_html
      else
        match # Return the original match if snippet is not found
      end
    end

    content.gsub!(/\{\{snippet_name:(.*?)\}\}/) do |match|
      snippet_identifier = $1&.strip
      snippet = Snippet.find_by(name: snippet_identifier)
      if snippet.present?
        # Parse the snippet content as a fragment
        fragment = Nokogiri::HTML::DocumentFragment.parse(snippet.content) #we inject this data-llama-snippet-id attribute to each node in the fragment so we know it's a global snippet. 
        
        # Add the data-llama-snippet-id attribute to each node in the fragment
        fragment.css('*').each do |node|
          node.set_attribute('data-llama-snippet-id', snippet.id)
        end
        
        # Convert the fragment back to HTML
        fragment.to_html
      else
        match # Return the original match if snippet is not found
      end
    end

    return content
  end

  # LlamaPress allows the user to edit the document by clicking in the page, and typing changes. 
  # The javascript code in _chat_contenteditable_javascript.html.erb will save those changes to the database using a POST request.
  # This method adds data-llama-editable attributes to all nodes in the HTML document. These attributes prevent ALL the html code that's in the document from being saved into the page database.
  # This is needed because modern browser plugins inject extra things into the page, and we need to exclude those from being saved, otherwise they will be saved to the database.
  def render_llama_contenteditable_tags(content)
    # Parse the content as a full HTML document
    document = Nokogiri::HTML5::Document.parse(content)

    # Add data-llama-editable attribute to all elements in the html page
    document.css('html *').each do |node|
      node.set_attribute('data-llama-editable', 'true')
    end    

    # Return the full HTML document as a string
    return document.to_html
  end

  def inject_chat_partial
    render_to_string(partial: 'shared/llama_bot/chat')
  end

  def inject_analytics_partial
    render_to_string(partial: 'shared/llama_bot/analytics')
  end

  def pre_save_processing
    add_llama_ids_to_content! #save llama_ids to sync with llamabot to ensure accurate edits
    prevent_overwriting_snippets! #prevent overwriting snippet templates with syntax: {{snippet_id:id}} to it's rendered html. This would happen when the user edits the page directly after the snippet is rendered if we didn't have this check.
    ensure_doctype_html! #ensure the document has a doctype html. When the user edits page directly from the browser, it's possible for the doctype to be removed on accident. We must have this <!DOCTYPE html> tag for the browser to render the page correctly.
  end

  # This method adds data-llama-id attributes to all nodes in the HTML document. These attributes help keep the code in sync with llamabot for highly accurate edits
  def add_llama_ids_to_content!
    # Parse the content as a full HTML document
    document = Nokogiri::HTML5::Document.parse(content)

    # Add data-llama-id attribute to all elements in the html page
    document.css('html *').each_with_index do |node, index|
      node.set_attribute('data-llama-id', index.to_s)
    end
    # Update the content attribute with the modified HTML
    self.content = document.to_html
  end

  # We don't want the user to overwrite snippets when they use contenteditable to edit the page.
  # This method checks for data-llama-snippet-id attribute, which means it was rendered from a {{snippet_id: 2}} or {{snippet_name: name}}
  # If it has this snippet-id or snippet-name, then this method prevents the user from overwriting it.
  # The limitation is that the user won't be able to edit the snippet from the page, but they won't accidentally overwrite it.
  # Eventually, we can detect if the user is editing a snippet, and then allow them to edit it globally for all pages.
  def prevent_overwriting_snippets!
    # Parse the content as a full HTML document
    document = Nokogiri::HTML5::Document.parse(self.content) #check for {{snippet_name:name}} and {{snippet_id:id}} and don't let the user overwrite those.
    document.css('html *').each do |node|
      if node.attributes['data-llama-snippet-id'].present?
        #swap the content of the node with the snippet 
        snippet_id = node.attributes['data-llama-snippet-id'].value
        snippet = Snippet.find_by(id: snippet_id)
        if snippet.present?
          node.swap(snippet.get_snippet_component)
        end
      end
    end
    self.content = document.to_html
  end

  def ensure_doctype_html!
    document = Nokogiri::HTML5::Document.parse(self.content)
    if !starts_with_doctype_html?(self.content)
      self.content = "<!DOCTYPE html>#{document.to_html}"
    end
  end

  # Ensure the web page has a web site. If not, create one so the user doesn't have to.
  def ensure_site
    return if site.present?
    return unless organization.present?

    self.site = organization.sites.first || create_new_site
  end

  def restore(page_history)
    self.save_history
    self.content = page_history.content
    self.save
  end

  def save_history(user_message = nil)
    user_message ||= "Restore to previous version"
    page_history = self.page_histories.create(content: self.content, user_message: user_message)
  end

  # Set the default html content for the web page
  def set_default_html_content
    if self.content.blank?
      self.content = PagesHelper.starting_html_content()
    end
  end

  private

  # Create a new web site for the organization
  def create_new_site
    name = generate_unique_name
    organization.sites.create!(name: name)
  end

  # Generate a unique name for the web site
  def generate_unique_name
    base_name = organization.name.presence || self.slug || 'LlamaPress Site'
    name = base_name
    index = 1

    while organization.sites.exists?(name: name)
      name = "#{base_name} #{index}"
      index += 1
    end

    name
  end

  def make_unique_slug
    original_slug = self.slug
    counter = 1
    while Page.exists?(slug: self.slug)
      self.slug = "#{original_slug}-#{counter}"
      counter += 1
    end
  end

  def controller
    @controller ||= ActionController::Base.new
  end
end
