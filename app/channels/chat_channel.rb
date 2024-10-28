require 'async/websocket/client'
require 'async/http/endpoint'
require 'async/reactor'
require 'json'  # Ensure JSON is required if not already

class ChatChannel < ApplicationCable::Channel
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
        message_content message.content
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