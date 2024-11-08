require 'websocket-client-simple'
require 'json'

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

  # LlamaBot subscribes to this channel in _websocket.html.erb.
  def subscribed
    stream_from "chat_channel_#{params[:session_id]}"
    Rails.logger.info "Subscribed to chat channel with session ID: #{params[:session_id]}"
    stream_for current_user
    
    @connection_id = SecureRandom.uuid
    Rails.logger.info "Created new connection with ID: #{@connection_id}"
    
    @worker = Thread.new do
      setup_external_websocket(@connection_id)
    end
  end

  def unsubscribed
    connection_id = @connection_id
    Rails.logger.info "Unsubscribing connection: #{connection_id}"
    
    if @worker && @worker[:connection_id] == connection_id
      @worker.kill
      @worker = nil
      Rails.logger.info "Killed worker thread for connection: #{connection_id}"
    end

    # Clean up the keepalive thread
    @keepalive_task&.kill
    
    # Close the websocket connection
    if @external_ws_connection
      @external_ws_connection.close
      Rails.logger.info "Closed external WebSocket connection for: #{connection_id}"
    end
  end

  # Receive messages from the llamabot/_chat.html.erb chatbot.
  def receive(data)
    # Log the incoming WebSocket data
    Rails.logger.info "Received data: #{data.inspect}"
    
    # Standardize field names so LlamaBot Backend can understand
    data["web_page_id"] = data["webPageId"]
    data["user_message"] = data["message"] 
    data["selected_element"] = data["selectedElement"] 
    
    # Fetch the contents of the file or webpage that user is currently editing
    data["file_contents"] = fetch_file_contents(data["context"], data["webPageId"])
    
    # Forward the processed data to the LlamaBot Backend Socket
    send_to_external_application(data)
  end

  private

  def setup_external_websocket(connection_id)
    Thread.current[:connection_id] = connection_id
    Rails.logger.info "Setting up external websocket for connection: #{connection_id}"

    # Store self reference to access instance methods inside the websocket block
    channel = self

    @external_ws_connection = WebSocket::Client::Simple.connect ENV['LLAMABOT_WEBSOCKET_URL'] do |ws|
      ws.on :message do |msg|
        # Use the stored reference to call the instance method
        channel.send(:handle_external_message, msg)
      end

      ws.on :open do
        Rails.logger.info "Connected to external WebSocket for connection: #{connection_id}"
      end

      ws.on :error do |e|
        Rails.logger.error "WebSocket Error: #{e.message}"
      end

      ws.on :close do |e|
        Rails.logger.info "WebSocket Connection Closed: #{e}"
      end
    end

    # Start keepalive pings in a separate thread
    @keepalive_task = Thread.new do
      send_keep_alive_pings(@external_ws_connection)
    end
  rescue => e
    Rails.logger.error "Failed to connect to external WebSocket for connection #{connection_id}: #{e.message}"
  end

  def handle_external_message(message)
    Rails.logger.info "Received from external WebSocket: #{message}"
    
    # Extract the message content
    message_content = message.data

    begin
      parsed_message = JSON.parse(message_content)
      case parsed_message["type"]
      when "write_code"
        Rails.logger.info "---------Received write_code message!----------"
        response = parsed_message['content']
        Rails.logger.info "---------------------> Response: #{response}"
        handle_write_code(response)
        Rails.logger.info "--------Completed write_code message!----------"
      when "pong"
        Rails.logger.debug "Received pong response"
        return  # skip broadcast on pong
      end
    rescue JSON::ParserError => e
      Rails.logger.error "Failed to parse message as JSON: #{e.message}"
    end

    # Broadcast the message to the public channel
    formatted_message = { message: message_content }.to_json
    ActionCable.server.broadcast "chat_channel_#{params[:session_id]}", formatted_message
  end

  def send_keep_alive_pings(connection)
    loop do
      sleep 30
      next if connection.closed?
      
      ping_message = {
        type: 'ping',
        connection_id: @connection_id,
        connection_state: 'connected',
        connection_class: connection.class.name
      }.to_json
      
      begin
        connection.send(ping_message)
        Rails.logger.debug "Sent keep-alive ping: #{ping_message}"
      rescue => e
        Rails.logger.error "Error sending keep-alive ping: #{e.message}"
      end
    end
  end

  def send_to_external_application(message)
    payload = message.to_json
    if @external_ws_connection && !@external_ws_connection.closed?
      begin
        @external_ws_connection.send(payload)
        Rails.logger.info "Sent message to external WebSocket: #{payload}"
      rescue => e
        Rails.logger.error "Error sending message to external WebSocket: #{e.message}"
      end
    else
      Rails.logger.error "External WebSocket connection not established or closed"
    end
  end
end