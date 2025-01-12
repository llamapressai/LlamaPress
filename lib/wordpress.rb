require 'net/http'
require 'uri'
require 'json'
require 'base64'

class Wordpress
  # rails c


  def self.test_authentication(wordpress_api_token)
    credentials = JSON.parse(wordpress_api_token)
    url = credentials['domain']
    username = credentials['username']
    auth_token = credentials['password']

    uri = URI.parse("#{url}/wp-json/wp/v2/users/me")
    request = Net::HTTP::Get.new(uri)
    request["Authorization"] = "Basic #{Base64.strict_encode64("#{username}:#{auth_token}")}"

    req_options = {
      use_ssl: uri.scheme == "https",
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end

    case response
    when Net::HTTPSuccess
      true
    else
      false
    end
  end

  def self.create_page!(wordpress_api_token, page)
    credentials = JSON.parse(wordpress_api_token)
    url = credentials['domain']
    username = credentials['username']
    auth_token = credentials['password']
    template_id = credentials['template_id']

    Rails.logger.info("Publishing for url: #{url} and username: #{username}")

    uri = URI.parse("#{url}/wp-json/wp/v2/pages")
    request = Net::HTTP::Post.new(uri)
    request.content_type = "application/json"
    request["Authorization"] = "Basic #{Base64.strict_encode64("#{username}:#{auth_token}")}"

    request.body = JSON.dump({
      "title" => page.slug,
      "content" => page.render_content,
      "template" => template_id,
      "status" => "publish"
    })

    req_options = {
      use_ssl: uri.scheme == "https",
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end

    case response
    when Net::HTTPSuccess
      JSON.parse(response.body)
    else
      raise "Failed to create WordPress page: #{response.code} #{response.message}"
    end
  end

  def self.see_all_pages(wordpress_api_token)
    credentials = JSON.parse(wordpress_api_token)
    url = credentials['domain']
    username = credentials['username']
    auth_token = credentials['password']

    uri = URI.parse("#{url}/wp-json/wp/v2/pages")
    request = Net::HTTP::Get.new(uri)
    request["Authorization"] = "Basic #{Base64.strict_encode64("#{username}:#{auth_token}")}"

    req_options = {
      use_ssl: uri.scheme == "https",
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end

    JSON.parse(response.body)
  end

  def self.read_page_by_route(wordpress_api_token, route, strip_attributes = false)
    credentials = JSON.parse(wordpress_api_token)
    url = credentials['domain']
    username = credentials['username']
    auth_token = credentials['password']

    uri = URI.parse("#{url}/wp-json/wp/v2/pages?slug=#{route}")
    request = Net::HTTP::Get.new(uri)
    request["Authorization"] = "Basic #{Base64.strict_encode64("#{username}:#{auth_token}")}"

    req_options = {
      use_ssl: uri.scheme == "https",
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end

    case response
    when Net::HTTPSuccess
      wp_json_response = JSON.parse(response.body)
      page_html = wp_json_response.first['content']['rendered']

      #TODO: Add data-llama-ids to each node on the page.
      page_html = self.add_llama_ids_to_page(page_html) #these data-llama-ids will match up with what the LLM responds telling us what to change.

      if strip_attributes
        return self.stripe_attributes_off_page(page_html), wp_json_response
      else
        return page_html, wp_json_response
      end
    else
      raise "Failed to read WordPress page: #{response.code} #{response.message}"
    end
  end

  def self.add_llama_ids_to_page(raw_page_html)
    # Parse the content as an HTML fragment instead of a full document
    fragment = Nokogiri::HTML5.fragment(raw_page_html)

    # Add data-llama-id attribute to all elements in the fragment
    fragment.css('*').each_with_index do |node, index|
      node.set_attribute('data-llama-id', index.to_s)
    end
    
    # Convert back to HTML string
    result = fragment.to_html
    # byebug
    result
  end

  # We're doing this so that if we send it to the LLM, there's way less tokens and noise for it to worry about and deal with, which will make it more accurate, and faster.
  def self.stripe_attributes_off_page(raw_page_html)
    # Wrap the fragment in a temporary div to ensure valid HTML structure
    doc = Nokogiri::HTML.fragment(raw_page_html)
    
    # Remove HTML comments
    # Remove HTML comments (including Font Awesome comments)
    doc.xpath('.//comment()').each(&:remove)
    
    # Also remove comments using regex as a fallback
    raw_html = doc.to_html
    raw_html.gsub!(/<!--.*?-->/m, '')
    doc = Nokogiri::HTML.fragment(raw_html)

    # Remove CDATA sections
    doc.xpath('.//text()').each do |node|
      if node.cdata?
        node.remove
      end
    end

    # Define tags we want to keep
    keep_tags = ['h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'p', 'span', 'li', 'ul', 'ol', 'a', 'img', 'br', 'hr', 'table', 'tr', 'td', 'th', 'thead', 'tbody', 'tfoot', 'caption', 'form', 'input', 'button', 'select', 'option', 'label', 'image']
    
    # Find all elements and process them
    doc.traverse do |node|
      if node.element?
        if ['svg', 'path', 'image', 'script'].include?(node.name.downcase) || 
           (!keep_tags.include?(node.name.downcase))
          # If the node has children and isn't in our keep list, replace it with its children
          if node.children.any?
            node.replace(node.children)
          else
            node.remove
          end
        else
          # For kept tags, strip all attributes except data-llama-id
          node.attributes.each do |name, _| 
            node.remove_attribute(name) unless name == 'data-llama-id'
          end
        end
      end
    end

    # Return the cleaned HTML
    doc.to_html
  end

  #TODO: Reconstruct the page with it's old attributes, and <script> tags, image tags, etc.
  #Question: Is putting this logic into the wordpress.rb file the best place for this? This wordpress.rb is more of an access layer, not a business logic layer.

  def self.write_page_by_route(wordpress_api_token, route, new_content)
    #TODO: Get just the children of the body tag.
    inner_html_content = Nokogiri::HTML.fragment(new_content).children.to_html

    #remove data-llama-ids from the inner_html_content
    inner_html_content.gsub!(/data-llama-id="\d+"/, '')

    credentials = JSON.parse(wordpress_api_token)
    url = credentials['domain']
    username = credentials['username']
    auth_token = credentials['password']

    # First get the page ID by route
    pages, json_response = read_page_by_route(wordpress_api_token, route)
    raise "Page not found with route: #{route}" if pages.empty?
    
    page_id = json_response.first['id']
    template_id = json_response.first['template']

    #TODO: This must use the same template as the original page.
    #TODO: This must not have the body or html tags, just the divs.

    # Prepare update request
    uri = URI.parse("#{url}/wp-json/wp/v2/pages/#{page_id}")
    request = Net::HTTP::Put.new(uri)
    request["Authorization"] = "Basic #{Base64.strict_encode64("#{username}:#{auth_token}")}"
    request["Content-Type"] = "application/json"
    request.body = JSON.dump({
      "content" => inner_html_content,
      "template" => template_id
    })

    req_options = {
      use_ssl: uri.scheme == "https",
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end

    case response
    when Net::HTTPSuccess
      JSON.parse(response.body)
    else
      raise "Failed to update WordPress page: #{response.code} #{response.message}"
    end
  end

  def self.update_wp_page_with_llamapress_page_contents(wordpress_api_token, route, page_id)
    #TODO: get the page contents from the LlamaPress page
    #TODO: update the WordPress page with the LlamaPress page contents
    #TODO: return the WordPress page
  end

  def self.write_page_by_route_and_llamapress_page_contents(wordpress_api_token, route, page_id)
    # Validate required parameters
    raise ArgumentError, "WordPress API token is required" if wordpress_api_token.blank?
    raise ArgumentError, "Route is required" if route.blank?
    raise ArgumentError, "Page ID is required" if page_id.blank?

    # Find the LlamaPress page by route
    page = Page.find(page_id)
    raise ActiveRecord::RecordNotFound, "No LlamaPress page found for route: #{route}" unless page

    # Get the rendered content from the page
    rendered_content = page.render_content

    # Write the page content to WordPress using the API
    self.write_page_by_route(wordpress_api_token, route, rendered_content)
  rescue => e
    Rails.logger.tagged('WordPress') do |logger|
      logger.error "Failed to write page content: #{e.message}"
      logger.error e.backtrace.join("\n")
    end
    raise
  end

  def self.get_cornerstone_exported_json_file(wordpress_api_token, page_id)
    credentials = JSON.parse(wordpress_api_token)
    # url = credentials['domain']
    url = "localhost:8889"
    username = credentials['username']
    auth_token = credentials['password']

    uri = URI.parse("#{url}/wp-json/llamapress/v1/cornerstone_page/#{page_id}")
    request = Net::HTTP::Get.new(uri)
    request["Authorization"] = "Basic #{Base64.strict_encode64("#{username}:#{auth_token}")}"

    req_options = {
      use_ssl: uri.scheme == "https",
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end

    case response
    when Net::HTTPSuccess
      JSON.parse(response.body)
    else
      raise "Failed to get Cornerstone export: #{response.code} #{response.message}"
    end
  end
end
