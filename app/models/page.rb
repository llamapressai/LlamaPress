class Page < ApplicationRecord
  include Rails.application.routes.url_helpers
  include ApplicationHelper
  extend FriendlyId

  belongs_to :site
  belongs_to :organization
  belongs_to :current_version, class_name: 'PageHistory', optional: true, foreign_key: 'current_version_id'
  
  has_many :page_histories, dependent: :destroy
  has_many :posts, dependent: :nullify
  has_many :chat_conversations, dependent: :destroy
  has_many :chat_messages, through: :chat_conversations 

  friendly_id :slug, use: :slugged

  before_validation :ensure_site, on: :create
  
  #TODO: Eventually we'll want it to be unique just for the individual sites -- validates :slug, uniqueness: { scope: :site_id, message: "must be unique within the site" }
  validates :slug, uniqueness: { message: "must be unique across all sites" }

  before_validation :make_unique_slug, on: :create

  after_initialize :set_default_html_content, if: :new_record?
  before_save :pre_save_processing, if: :content_changed?
  after_create :save_initial_history # create initial page history

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

  def save_initial_history
    puts "\n=== Starting save_initial_history ==="
    puts "Initial user_message: Initial Save"

    return unless persisted?
    puts "Page is persisted, continuing..."

    user_message = "Initial Save"
    history = self.page_histories.create(content: self.content, user_message: user_message)
    puts "New history created: #{history.inspect}"

    self.update_column(:current_version_id, history.id)
    puts "Updated current_version_id to: #{history.id}"

    history
  end

  def save_history(user_message = nil)
    puts "\n=== Starting save_history ==="
    puts "Initial user_message: #{user_message.inspect}"
    
    return unless persisted?  # Make sure the page is saved first
    puts "Page is persisted, continuing..."
    
    user_message ||= "Save version"
    puts "Final user_message: #{user_message}"
    
    # 03/03/2025, There was an error getting thrown here for new pages, because current_version_id was not set on initial creation. I don't know 
    # the root cause of this, but I know that the error was happening because current_version_id was not set.

    ## I'm not able to reproduce this error, but I know it was happening for a minute, so I'm going to 
    # keep this code here temporarily in case we notice it happening again.

    # This was an attempted fix at that: 
    # Check if there's a previous history entry with the same content
    # if (current_version_id.blank?)
    #   puts "No current version id, creating initial history"
    #   history = self.page_histories.create(content: self.content, user_message: user_message)
    #   self.update_column(:current_version_id, history.id)
    # end
    
    current_history = page_histories.find_by(id: current_version_id)
    puts "Current history found: #{current_history.inspect}"
    
    same = current_history&.content == self.content
    puts "Content is same as current history? #{same}"

    if same
      puts "=== Returning existing history (no changes) ==="
      return current_history
    end
    
    # If we're saving from a previous version, prune future versions
    # if current_history
    #   page_histories.where('created_at > ?', current_history.created_at).destroy_all
    # end

    # Create new history entry if content is different
    puts "Creating new history entry..."
    history = self.page_histories.create(content: self.content, user_message: user_message)
    puts "New history created: #{history.inspect}"
    
    puts "Updating current_version_id to: #{history.id}"
    self.update_column(:current_version_id, history.id)
    history
  end

  # Set the default html content for the web page
  def set_default_html_content
    if self.content.blank?
      self.content = PagesHelper.starting_html_content()
    end
  end

  def set_default_html_content_for_picture_to_html
      self.content = PagesHelper.starting_html_content_for_picture_to_html()
  end

  def next_version
    return nil unless current_version
    
    # Get all versions, ordered by creation time
    versions = page_histories.order(created_at: :asc).to_a
    
    # Find the index of the current version
    current_index = versions.index { |v| v.id == current_version_id }
    return nil if current_index.nil? || current_index >= versions.length - 1
    
    # Return the immediately following version
    versions[current_index + 1]
  end

  def previous_version
    return nil unless current_version
    
    # Get all versions up to the current one, ordered by creation time
    versions = page_histories.order(created_at: :asc).to_a
    
    # Find the index of the current version
    current_index = versions.index { |v| v.id == current_version_id }
    return nil if current_index.nil? || current_index == 0
    
    # Return the immediately preceding version
    versions[current_index - 1]
  end

  def undo
    return false unless current_version
    previous = previous_version
    
    if previous
      restore_with_history(previous, "Undo to previous version")
      true
    else
      false
    end
  end

  def redo
    return false unless current_version
    next_ver = next_version
    
    if next_ver
      restore_with_history(next_ver, "Redo to next version")
      true
    else
      false
    end
  end

  def current_version
    return nil unless current_version_id
    page_histories.find_by(id: current_version_id)
  end

  def version_number
    return 0 unless current_version_id
    page_histories.where('created_at <= ?', current_version.created_at).count
  end

  def total_versions
    page_histories.count
  end

  def latest_version?
    return true unless current_version_id
    !page_histories.where('created_at > ?', current_version.created_at).exists?
  end

  def first_version?
    return true unless current_version_id
    !page_histories.where('created_at < ?', current_version.created_at).exists?
  end


  def restore_with_history(page_history, message)
    self.content = page_history.content
    self.current_version_id = page_history.id
    # Use update_columns to skip callbacks and avoid creating another history entry
    self.update_columns(
      content: page_history.content,
      current_version_id: page_history.id
    )
  end

  def publish_to_wordpress!
    Rails.logger.info("Publishing to WordPress for page #{self.id}")
    if self.published_to_wordpress?
      Rails.logger.info("Updating WordPress page #{self.wordpress_page_id}")
      response = Wordpress.update_page!(site.wordpress_api_decoded_token, self)
    else
      Rails.logger.info("Creating WordPress page")
      response = Wordpress.create_page!(site.wordpress_api_decoded_token, self)
      self.wordpress_page_id = response['id']
      self.save
    end
    return response
  end

  def published_to_wordpress?
    self.wordpress_page_id.present?
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
