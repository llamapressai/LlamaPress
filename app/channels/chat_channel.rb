require 'async/websocket/client'
require 'async/http/endpoint'
require 'async/reactor'
require 'json'  # Ensure JSON is required if not already

class ChatChannel < ApplicationCable::Channel
  def fetch_file_contents(context, web_page_id=nil)
    file_path = context || "app/views/llama_bot/home.html.erb"

    should_we_edit_html_in_webpage_database = file_path.include?("pages/show") && !web_page_id&.empty?
    @web_page = web_page_id&.empty? ? nil : Page.find_by(id: web_page_id)
    
    # Load the HTML content from the database or the file system
    file_contents = should_we_edit_html_in_webpage_database ? @web_page&.render_content : File.read(file_path)

    return file_contents
  end

  def handle_write_code(response)
    code_to_write = response['payload']['code']
    destination = response['payload']['destination']
    should_we_write_page_to_database = response["query_params"]["context"].include? "pages/show"
    
    # Check if the response contains snippets
    doc = Nokogiri::HTML.fragment(code_to_write)
    snippet_elements = doc.css('[data-llama-snippet-id]')
  
    if snippet_elements.any?
      snippet_elements.each do |snippet_element|
        snippet_id = snippet_element['data-llama-snippet-id']
        snippet_content = snippet_element.to_html
  
        # Update the snippet in the database if it exists
        # Temporary: disable saving snippet to database when LLM responds (we need snippet history before we implement this, we keep overwriting the snippet on accident)
        # snippet = Snippet.find_by(id: snippet_id)
        # if snippet
        #   snippet.update(content: snippet_content)
        # else
        #   return "Snippet with ID #{snippet_id} not found."
        # end
      end
    end
  
    if should_we_write_page_to_database
      # Write the full page content to the database
      web_page = Page.find_by(id: response['query_params']['web_page_id'])
      if web_page
        web_page.update(content: code_to_write)
        PageHistory.create(
          page_id: web_page.id, 
          content: code_to_write, 
          prompt: response['query_params']['user_message'], 
          user_message: response['query_params']['user_message']
        )
      else
        return "Web page not found."
      end
    elsif ENV['SANDBOX_MODE'] == 'true'
      # If in sandbox mode, reject file write
      return "Sorry, but we're in sandbox mode. You can't write code to the filesystem in sandbox mode."
    else
      # Write the code to the specified file destination
      File.write(destination, code_to_write)
    end
  
    return "Got it! Snippets have been updated and here is the code you asked for: #{code_to_write}. Refresh your browser to see the new code."
  end

  def subscribed
    stream_from "chat_channel_#{params[:session_id]}"
    Rails.logger.info "Subscribed to chat channel with session ID: #{params[:session_id]}"
    stream_for current_user

    setup_external_websocket
  end

  def unsubscribed
    # Clean up the connection
    if @external_ws_connection
      @external_ws_connection.close
      Rails.logger.info "Closed external WebSocket connection"
    end
  end

  def receive(data)
    Rails.logger.info "Received data: #{data.inspect}"
    data["user_message"] = data["message"]
    data["file_contents"] =  fetch_file_contents(data["context"], data["webPageId"])
    send_to_external_application(data)
  end

  private

  def setup_external_websocket
    Rails.logger.info "Setting up external websocket"

    endpoint = Async::HTTP::Endpoint.parse('ws://localhost:8000/ws')

    # Initialize the connection and store it in an instance variable
    @external_ws_task = Async do |task|
      begin
        @external_ws_connection = Async::WebSocket::Client.connect(endpoint)
        Rails.logger.info "Connected to external WebSocket"

        # Start listening for messages from the external server
        task.async do
          listen_to_external_websocket(@external_ws_connection)
        end

        # Optional: Set up a keep-alive ping
        # task.async do
        #   send_keep_alive_pings(@external_ws_connection)
        # end
      rescue => e
        Rails.logger.error "Failed to connect to external WebSocket: #{e.message}"
      end
    end
  end

  def listen_to_external_websocket(connection)
    while message = connection.read
      Rails.logger.info "Received from external WebSocket: #{message}"
      # Extract the actual message content
      if message.buffer
        message_content = message.buffer  # Use .data to get the message content
      else
        message_content = message.content
      end

      begin
        parsed_message = JSON.parse(message_content)
        if parsed_message["type"] == "write_code"
          Rails.logger.info "---------Received write_code message!----------"
          response = parsed_message['content']
          handle_response!(response)
          # Add any additional handling for write_code messages here
        end
      rescue JSON::ParserError => e
        Rails.logger.error "Failed to parse message as JSON: #{e.message}"
      end


      formatted_message = { message: message_content }.to_json
      ActionCable.server.broadcast "chat_channel_#{params[:session_id]}", formatted_message
    end
  end

  def send_keep_alive_pings(connection)
    loop do
      sleep 30
      ping_message = { type: 'ping' }.to_json
      connection.write(ping_message)
      Rails.logger.debug "Sent keep-alive ping: #{ping_message}"
    end
  rescue => e
    Rails.logger.error "Error in keep-alive ping: #{e.message}"
  end

  def send_to_external_application(message)
    payload = message.to_json
    if @external_ws_connection
      begin
        @external_ws_connection.write(payload)
        Rails.logger.info "Sent message to external WebSocket: #{payload}"
      rescue => e
        Rails.logger.error "Error sending message to external WebSocket: #{e.message}"
      end
    else
      Rails.logger.error "External WebSocket connection not established"
      # Optionally, you might want to attempt to reconnect here
    end
  end
end