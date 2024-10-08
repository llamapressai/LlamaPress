class Page < ApplicationRecord
  include Rails.application.routes.url_helpers

  extend FriendlyId
  belongs_to :site
  belongs_to :organization
  has_many :page_histories, dependent: :destroy

  before_validation :ensure_site, on: :create
  after_initialize :set_default_html_content, if: :new_record?

  friendly_id :slug, use: :slugged
  before_save :add_llama_ids_to_content, if: :content_changed?
  before_save :prevent_overwriting_snippets, if: :content_changed?

  def render_content
    content = self.content
    content = render_snippets(content)
    content = render_llama_contenteditable_tags(content)
    return content
  end

  def render_snippets(content)
    # a snippet is something like {{snippet:header}} or {{snippet:footer}}
    # for each {{ in the content, see if there is a matching snippet
    # if so, replace the {{snippet:name}} with the snippet content

    # make this work by snippet id, and by snippet name
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
        
        # Add the data-llama-snippet-id attribute to each node in the fragment
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

  # LlamaPress allows the user can edit the document by clicking in the page, and typing changes. 
  # The javascript code in _chat_contenteditable_javascript.html.erb will save those changes to the database using a POST request.
  # This method adds data-llama-editable attributes to all nodes in the HTML document. These attributes prevent ALL the html code that's in the document from being saved into the page database.
  # This is needed because modern browser plugins inject extra things into the page, and we need to exclude those from being saved, otherwise they will be saved to the database.
  def render_llama_contenteditable_tags(content)
    # Parse the content as a full HTML document
    document = Nokogiri::HTML::Document.parse(content)

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

  def add_llama_ids_to_content
    # Parse the content as a fragment instead of a full document
    fragment = Nokogiri::HTML::DocumentFragment.parse(self.content)
  
    # Add data-llama-id attribute to all elements in the fragment
    fragment.css('*').each_with_index do |node, index|
      node.set_attribute('data-llama-id', index.to_s)
    end
  
    # Create a new HTML5 document
    document = Nokogiri::HTML5::Document.new
    document.encoding = 'UTF-8'
  
    # Create and append html and body elements if they don't exist
    html_node = fragment.at_css('html') || document.create_element('html')
    body_node = html_node.at_css('body') || document.create_element('body')
  
    # Move all top-level nodes of the fragment into the body
    fragment.children.each { |child| body_node.add_child(child) }
    html_node.add_child(body_node) unless html_node.at_css('body')
    document.add_child(html_node)
  
    # Update the content attribute with the modified HTML
    self.content = document.to_html
  end


  # We don't want the user to overwrite snippets when they use contenteditable to edit the page.
  # This method checks for data-llama-snippet-id attribute, which means it was rendered from a {{snippet_id: 2}} or {{snippet_name: name}}
  # If it has this snippet-id or snippet-name, then this method prevents the user from overwriting it.
  # The limitation is that the user won't be able to edit the snippet from the page, but they won't accidentally overwrite it.
  # Eventually, we can detect if the user is editing a snippet, and then allow them to edit it globally for all pages.
  def prevent_overwriting_snippets()
    # Parse the content as a full HTML document
    document = Nokogiri::HTML::Document.parse(self.content) #check for {{snippet_name:name}} and {{snippet_id:id}} and don't let the user overwrite those.
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

  def controller
    @controller ||= ActionController::Base.new
  end
end
