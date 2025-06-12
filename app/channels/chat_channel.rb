require 'async/websocket/client'
require 'async/http/endpoint'
require 'async/reactor'
require 'json'  # Ensure JSON is required if not already

class ChatChannel < ApplicationCable::Channel
  include ChatHelper  # Add this line to include the helper module

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
    should_we_write_page_to_database = true #response["query_params"]["context"]&.include? "pages/show"
    # Check if the response contains snippets
    doc = Nokogiri::HTML.fragment(code_to_write)
    snippet_elements = doc.css('[data-llama-snippet-id]')
    user_message = extract_user_message(response['query_params']['user_message'])
  
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
          prompt: user_message, 
          user_message: user_message
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

  # _chat.html.erb front-end subscribes to this channel in _websocket.html.erb.
  def subscribed
    begin
      reject unless current_user
      stream_from "chat_channel_#{params[:session_id]}" # Public stream for session-based messages <- this is the channel we're subscribing to in _websocket.html.erb
      Rails.logger.info "Subscribed to chat channel with session ID: #{params[:session_id]}"
      stream_for current_user
      
        @connection_id = SecureRandom.uuid
      Rails.logger.info "Created new connection with ID: #{@connection_id}"
      
      # Use a begin/rescue block to catch thread creation errors
    begin
      @worker = Thread.new do
          Thread.current[:connection_id] = @connection_id
        Thread.current.abort_on_exception = true  # This will help surface errors
        setup_external_websocket(@connection_id)
      end
    rescue => e
      Rails.logger.error "Error in WebSocket subscription: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      
      # Send error message to frontend before rejecting
      begin
        send_message_to_frontend("error", "Failed to establish chat connection: #{e.message}")
      rescue => send_error
        Rails.logger.error "Could not send error to frontend: #{send_error.message}"
      end
      
      reject # Reject the connection if there's an error
      end
    rescue ThreadError => e
      Rails.logger.error "Failed to allocate thread: #{e.message}"
      # Handle the error gracefully - potentially notify the client
      send_message_to_frontend("error", "Failed to establish connection: #{e.message}")
    end
  end

  def unsubscribed
    connection_id = @connection_id
    Rails.logger.info "Unsubscribing connection: #{connection_id}"
    
    begin
      # Only kill the worker if it belongs to this connection
      if @worker && @worker[:connection_id] == connection_id
        begin
          @worker.kill
          @worker = nil
          Rails.logger.info "Killed worker thread for connection: #{connection_id}"
        rescue => e
          Rails.logger.error "Error killing worker thread: #{e.message}"
        end
      end

      # Clean up async tasks with better error handling
      begin
        @listener_task&.stop rescue nil
        @keepalive_task&.stop rescue nil
        @external_ws_task&.stop rescue nil
      rescue => e
        Rails.logger.error "Error stopping async tasks: #{e.message}"
      end
      
      # Clean up the connection
      if @external_ws_connection
        begin
          @external_ws_connection.close
          Rails.logger.info "Closed external WebSocket connection for: #{connection_id}"
        rescue => e
          Rails.logger.warn "Could not close WebSocket connection: #{e.message}"
        end
      end
      
      # Force garbage collection in development/test environments to help clean up
      if !Rails.env.production?
        GC.start
      end
    rescue => e
      Rails.logger.error "Fatal error during channel unsubscription: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
    end
  end

  # Receive messages from _chat.html.erb frontend and send to llamabot FastAPI backend, frontend comes from the llamabot/_chat.html.erb chatbot, sent
  # through external websocket to FastAPI/Python backend.
  def receive(data)
    begin
      Rails.logger.info "LlamaPress Message Received from frontend!"
      Rails.logger.info "Data: #{data["message"]} #{data["webPageId"]}"
      Rails.logger.info "Current User: #{current_user.public_id}"

      #used to validate the message before it's sent to the backend.
      validate_message(data) #Placeholder for now, we are using this to mock errors being thrown. In the future, we can add actual validation logic.

      # Standardize field names so LlamaBot Backend can understand
      data["web_page_id"] = data["webPageId"]
      data["user_message"] = data["message"]
      data["selected_element"] = data["selectedElement"] 
      data["user_llamapress_api_token"] = current_user.api_token
      
      # Fetch the contents of the file or webpage that user is currently editing
      data["file_contents"] = fetch_file_contents(data["context"], data["webPageId"])

      message = data["message"]

      #In this case, conversation short-term memory belongs to a page
      chat_conversation = ChatConversation.find_by(page_id: data["webPageId"])
      if chat_conversation.nil?
          chat_conversation = ChatConversation.create(page_id: data["webPageId"], user: current_user)
      end

      data["previous_messages"] = chat_conversation.chat_messages.map do |msg|
        {
          "role" => msg.ai_message? ? "assistant" : "user",
          "content" => msg.content
        }
      end


      @web_page = Page.find_by(id: data["webPageId"])
      
       # Add site's system_prompt to the data if it exists
      if @web_page&.site&.system_prompt.present?
        data["system_prompt"] = @web_page.site.system_prompt
      end

      # Add site's llamabot_agent_name to the data if it exists
      if @web_page&.site&.llamabot_agent_name.present?
        data["llamabot_agent_name"] = @web_page.site.llamabot_agent_name # this is so the user can choose the agent they want to use
      end 
      
      if @web_page.site.wordpress_api_encoded_token.present?
        data["wordpress_api_encoded_token"] = @web_page.site.wordpress_api_encoded_token
      else
        data["wordpress_api_encoded_token"] = nil
      end

      chat_message = ChatMessage.create(content: message, user: current_user, chat_conversation: chat_conversation, sender: ChatMessage.senders[:human_message], created_at: Time.now)
      
      # Forward the processed data to the LlamaBot Backend Socket
      send_to_external_application(data)
      # Log the incoming WebSocket data
      Rails.logger.info "Got message from Javascript LlamaBot Frontend: #{data.inspect}"
    rescue => e
      Rails.logger.error "Error in receive method: #{e.message}"
      send_message_to_frontend("error", e.message)
    end
  end

  def send_message_to_frontend(type, message, trace_info = nil)
    # Log trace info for debugging
    Rails.logger.info "TRACE INFO DEBUG: Type: #{type}, Has trace info: #{trace_info.present?}"
    if trace_info.present?
      Rails.logger.info "TRACE INFO CONTENT: #{trace_info.inspect}"
    end
  

    message_data = {
      type: type,
      content: message
    }
    
    # Add trace information if available
    if trace_info.present?
      message_data[:langsmith_trace] = trace_info
      
      # Save trace info with the message in the database
      if type == 'ai_message'
        begin
          # Find the chat conversation for this session or page
          conversation = if params[:session_id].present?
            ChatConversation.find_by(session_id: params[:session_id])
          elsif params[:web_page_id].present?
            ChatConversation.find_by(page_id: params[:web_page_id])
          end
          
          Rails.logger.info "TRACE DEBUG: Found conversation? #{conversation.present?} with ID: #{conversation&.id}"
          
          if conversation.present?
            # Find the most recent AI message in this conversation
            chat_message = conversation.chat_messages.where(sender: ChatMessage.senders[:ai_message]).order(created_at: :desc).first
            
            Rails.logger.info "TRACE DEBUG: Found message? #{chat_message.present?} with ID: #{chat_message&.id}"
            
            if chat_message.present?
              # Update with trace info
              trace_id = trace_info[:trace_id] || trace_info['trace_id']
              trace_url = trace_info[:trace_url] || trace_info['trace_url']
              
              Rails.logger.info "TRACE DEBUG: Updating message with trace_id: #{trace_id}, trace_url: #{trace_url}"
              
              success = chat_message.update(
                trace_id: trace_id,
                trace_url: trace_url
              )
              
              Rails.logger.info "TRACE DEBUG: Update success: #{success}, errors: #{chat_message.errors.full_messages.join(', ')}"
            end
          end
        rescue => e
          Rails.logger.error "ERROR SAVING TRACE INFO: #{e.message}"
          Rails.logger.error e.backtrace.join("\n")
        end
      end
    end
    
    formatted_message = { message: message_data.to_json }.to_json
    
    ActionCable.server.broadcast "chat_channel_#{params[:session_id]}", formatted_message
  end

  private

  def setup_external_websocket(connection_id)
    Thread.current[:connection_id] = connection_id
    Rails.logger.info "Setting up external websocket for connection: #{connection_id}"
    # endpoint = Async::HTTP::Endpoint.parse(ENV['LLAMABOT_WEBSOCKET_URL']) 
    uri = URI(ENV['LLAMABOT_WEBSOCKET_URL'])
    
    uri.scheme = 'wss'
    uri.scheme = 'ws' if ENV['DEVELOPMENT_ENVIRONMENT'] == 'true'

    endpoint = Async::HTTP::Endpoint.new(
        uri,
        ssl_context: OpenSSL::SSL::SSLContext.new.tap do |ctx|
            ctx.verify_mode = OpenSSL::SSL::VERIFY_PEER
            if ENV["STAGING_ENVIRONMENT"] == 'true'
              ctx.ca_file = '/usr/local/etc/ca-certificates/cert.pem'
              # M2 Air : ctx.ca_file = '/etc//ssl/cert.pem'
              ctx.cert = OpenSSL::X509::Certificate.new(File.read(File.expand_path('~/.ssl/llamapress/cert.pem')))
              ctx.key = OpenSSL::PKey::RSA.new(File.read(File.expand_path('~/.ssl/llamapress/key.pem')))
            elsif ENV['DEVELOPMENT_ENVIRONMENT'] == 'true'
              # do no ctx stuff
              ctx.verify_mode = OpenSSL::SSL::VERIFY_NONE   
            else  # production
              ctx.ca_file ='/etc/ssl/certs/ca-certificates.crt'
            end
        end
    )

    # Initialize the connection and store it in an instance variable
    @external_ws_task = Async do |task|
      begin
        @external_ws_connection = Async::WebSocket::Client.connect(endpoint)
        Rails.logger.info "Connected to external WebSocket for connection: #{connection_id}"
        
        #Tell llamabot frontend that we've connected to the backend
        formatted_message = { message: {type: "external_ws_pong"} }.to_json
        ActionCable.server.broadcast "chat_channel_#{params[:session_id]}", formatted_message
        
        # Store tasks in instance variables so we can clean them up later
        @listener_task = task.async do
          listen_to_external_websocket(@external_ws_connection)
        end

        @keepalive_task = task.async do
          send_keep_alive_pings(@external_ws_connection)
        end

        # Wait for tasks to complete or connection to close
        [@listener_task, @keepalive_task].each(&:wait)
      rescue => e
        Rails.logger.error "Failed to connect to external WebSocket for connection #{connection_id}: #{e.message}"
      ensure
        # Clean up tasks if they exist
        @listener_task&.stop
        @keepalive_task&.stop
        @external_ws_connection&.close
      end
    end
  end

  # Listen for messages from the LlamaBot Backend
  def listen_to_external_websocket(connection)
    while message = connection.read

      #Try to fix the ping/pong issue keepliave
      # if message.type == :ping
      
      #   # respond with :pong
      #   connection.write(Async::WebSocket::Messages::ControlFrame.new(:pong, frame.data))
      #   connection.flush
      #   next
      # end
      # Extract the actual message content
      if message.buffer
        message_content = message.buffer  # Use .data to get the message content
      else
        message_content = message.content
      end

      Rails.logger.info "Received from external WebSocket: #{message_content}"

      begin
        parsed_message = JSON.parse(message_content)
        case parsed_message["type"]
        when "think_message"
          Rails.logger.info "---------Received think_message message!----------"
          response = parsed_message['content']
          formatted_message = { message: message_content }.to_json
          Rails.logger.info "---------------------> Response: #{response}"
          Rails.logger.info "---------Completed think_message message!----------"
        when "fragment_from_html_stream_message"
          Rails.logger.info "---------Received fragment_from_html_stream_message message!----------"
          response = parsed_message['content']
          formatted_message = { message: message_content }.to_json
          Rails.logger.info "---------------------> Response: #{response}"
          Rails.logger.info "---------Completed fragment_from_html_stream_message message!----------"
          # Broadcast the message to the public channel so llamabot/_chat.html.erb can display it
        when "system_message"
          Rails.logger.info "---------Received system_message message!----------"
          response = parsed_message['content']
          Rails.logger.info "---------------------> Response: #{response}"

          # Broadcast the message to the public channel so llamabot/_chat.html.erb can display it
          formatted_message = { message: message_content }.to_json

          #Get the last chat conversation for this page and save this message to it
          # chat_conversation = ChatConversation.find_by(page_id: parsed_message["page_id"])
          # if chat_conversation.nil?
          #   chat_conversation = ChatConversation.create(page_id: parsed_message["page_id"], user: current_user)
          # end
          # chat_message = ChatMessage.create(content: response, user: current_user, chat_conversation: chat_conversation, sender: ChatMessage.senders[:ai_message], created_at: Time.now)

          Rails.logger.info "--------Completed system_message message!----------"
        
        when "ai_message"
          response = parsed_message["content"]
          if parsed_message["content"].blank? && parsed_message["additional_kwargs"].to_s.include?("tool_call")
            # response = "🧠: " + (parsed_message["additional_kwargs"]["tool_calls"][0]["function"]["name"]&.titleize) + " called with arguments: " + parsed_message["additional_kwargs"]["tool_calls"][0]["function"]["arguments"]

            #WARNING: Terrible things were happening here. 
            # It was causing malformed messages to be sent to LlamaBot, breaking the entire 
            # LlamaBot thread. We would get OpenAI 400 errors because the tool-calling got malformed somehow for the entire thread.

            # Instead, I went straight to _websocket.html.erb and added the formatting logic there.
            #TODO: We need to refactor message parsing & display for tool-calling to use the 🧠
            # Refactor in: _websocket.html.erb, _core_javascript.html.erb, chat_channel.rb, and pages_controller.rb.
            # We need to DRY up this code.

            # message_content.replace("content\":\"", "content:\"#{response}\"")
            # message_content = message_content.sub!("content:\"", "content\":\"#{response}\"")
            
            # "{\"type\":\"ai_message\",\"content\":\"\",\"additional_kwargs\":{\"tool_calls\":[{\"index\":0,\"id\":\"call_hvz1acVxJexmvdEeULwDW180\",\"function\":{\"arguments\":\"{\\\"weight\\\":155,\\\"height\\\":72}\",\"name\":\"calculate_bmi_tool\"},\"type\":\"function\"}]}}"
            # "{\"type\":\"ai_message\",\"content\":\"0.0357396449704142\",\"additional_kwargs\":{}}"

            # json = JSON.parse(message_content)
            # json["content"] = response
            # message_content = json.to_s
          end

          Rails.logger.info "---------Received ai_message message!----------"
          trace_info = parsed_message['langsmith_trace']
          Rails.logger.info "---------------------> Response: #{response}"
          Rails.logger.info "---------Completed ai_message message!----------"

          # Include trace info in the formatted message
          message_content_with_trace = message_content
          formatted_message = { message: message_content_with_trace }.to_json

          #In this case, conversation short-term memory belongs to a page
          web_page_id = parsed_message["web_page_id"]
          Rails.logger.info "---------Web Page Id: #{web_page_id} ----------"
          begin 
            if web_page_id.present?
              chat_conversation = ChatConversation.find_by(page_id: web_page_id)
              
              if chat_conversation.nil?
                chat_conversation = ChatConversation.create(page_id: web_page_id, user: current_user)
              end

              # Store trace info in the chat message
              chat_message = ChatMessage.create(
                content: response, 
                user: current_user, 
                chat_conversation: chat_conversation, 
                sender: ChatMessage.senders[:ai_message], 
                created_at: Time.now,
                trace_id: trace_info&.dig('trace_id'),
                trace_url: trace_info&.dig('trace_url')
              )
              chat_message.save!

            end
          rescue => e
            Rails.logger.error "Error saving chat message: #{e.message}"
          end

        when "write_code"
          tracing_info = parsed_message["langsmith_trace"]
          Rails.logger.info "---------Received write_code message!----------"
          response = parsed_message['content']
          trace_info = parsed_message['langsmith_trace']
          Rails.logger.info "---------------------> Response: #{response}"
          #This is where the the magic happens. Write the new HTML code directly to the database.
          result = handle_write_code(response)

          # Save trace info if available for write_code messages
          web_page_id = parsed_message["web_page_id"]

          if trace_info.present? && web_page_id.present?
            begin
              chat_conversation = ChatConversation.find_by(page_id: web_page_id)
              
              if chat_conversation.nil?
                chat_conversation = ChatConversation.create(page_id: web_page_id, user: current_user)
              end
              
              # Create a record of this write_code action with trace info
              chat_message = ChatMessage.create(
                content: "Code update: #{response['payload']['destination'] if response['payload']}",
                user: current_user,
                chat_conversation: chat_conversation,
                sender: ChatMessage.senders[:ai_message],
                created_at: Time.now,
                trace_id: trace_info.dig('trace_id'),
                trace_url: trace_info.dig('trace_url')
              )
              Rails.logger.info "Saved trace info for write_code message: #{chat_message.id}"
            rescue => e
              Rails.logger.error "Error saving trace info for write_code: #{e.message}"
            end
          end

          formatted_message = { message: message_content }.to_json
          Rails.logger.info "--------Completed write_code message!----------"
          # Add any additional handling for write_code messages here
        when "error"
          Rails.logger.error "---------Received error message!----------"
          response = parsed_message['content']
          formatted_message = { message: message_content }.to_json
          Rails.logger.error "---------------------> Response: #{response}"
          Rails.logger.error "---------Completed error message!----------"
        when "pong"
          Rails.logger.debug "Received pong response"
          # Tell llamabot frontend that we've received a pong response, and we're still connected
          formatted_message = { message: {type: "external_ws_pong"} }.to_json
        end
      rescue JSON::ParserError => e
        Rails.logger.error "Failed to parse message as JSON: #{e.message}"
      end
      ActionCable.server.broadcast "chat_channel_#{params[:session_id]}", formatted_message
    end
  end

  # TODO: Send keep-alive pings to the LlamaBot Backend
  def send_keep_alive_pings(connection)
    loop do
      ping_message = {
        type: 'ping',
        connection_id: @connection_id,
        connection_state: !connection.closed? ? 'connected' : 'disconnected',
        connection_class: connection.class.name
      }.to_json
      connection.write(ping_message)
      connection.flush
      Rails.logger.debug "Sent keep-alive ping: #{ping_message}"
      Async::Task.current.sleep(30)
    end
  rescue => e
    Rails.logger.error "Error in keep-alive ping: #{e.message} | Connection type: #{connection.class.name}"
  end

  # Send messages from the user to the LlamaBot Backend Socket
  def send_to_external_application(message)
    #   ChatMessage.create(content: message_content, user: current_user, chat_conversation: ChatConversation.last, ai_chat_message: true, created_at: Time.now)

    payload = message.to_json
    if @external_ws_connection
      begin
        @external_ws_connection.write(payload)
        @external_ws_connection.flush
        Rails.logger.info "Sent message to external WebSocket: #{payload}"
      rescue => e
        Rails.logger.error "Error sending message to external WebSocket: #{e.message}"
      end
    else
      Rails.logger.error "External WebSocket connection not established"
      # Optionally, you might want to attempt to reconnect here
    end
  end

  # Helper function to extract text from <user></user> tags
  def extract_user_message(message)
    return message unless message.is_a?(String)
    
    # Check if message contains <user> tags
    if message.match?(/<user>.*<\/user>/m)
      # Extract content between <user> tags
      extracted = message.match(/<user>(.*?)<\/user>/m)&.[](1)
      # Return extracted content or original message if extraction fails
      return extracted || message
    end
    
    # Return original message if no <user> tags are present
    message
  end

    # used to validate the message before it's sent to the backend. 
    # Essentially a placeholder for now, we are using this to mock errors being thrown. In the future, we can add actual validation logic.
    # See chat_channel_test.rb:"error thrown in receive method is handled and sent to frontend" for more info.
  def validate_message(data)
    # This is a simple method that can be easily mocked
    true
  end
end  # Single end statement to close the ChatChannel class

