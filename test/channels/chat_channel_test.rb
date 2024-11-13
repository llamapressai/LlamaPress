require "test_helper"
require 'mocha/minitest'

class ChatChannelTest < ActionCable::Channel::TestCase
  include Devise::Test::IntegrationHelpers
  setup do
    @user = users(:one)
    sign_in @user
    @page = pages(:one)
    # Mock the current_user method to return nil in test environment
    ChatChannel.any_instance.stubs(:current_user).returns(nil)
    @chat_conversation = chat_conversations(:one)
  end

  def teardown
    # Clean up any async tasks and connections
    @channel&.instance_variable_get(:@listener_task)&.stop
    @channel&.instance_variable_get(:@keepalive_task)&.stop
    @channel&.instance_variable_get(:@external_ws_task)&.stop
    @channel&.instance_variable_get(:@worker)&.kill if @channel&.instance_variable_get(:@worker)
    
    # Clean up Mocha stubs
    Mocha::Mockery.instance.teardown
    
    super
  end

  # test "subscribes" do
  #   subscribe
  #   assert subscription.confirmed?
  # end

  test "send_to_external_application" do
    # Setup
    connection = stub('websocket_connection')
    @channel = subscribe
    @channel.instance_variable_set(:@external_ws_connection, connection)
    
    message = { 
      "message" => "Hello",
      "context" => "some_context"
    }
    expected_payload = message.to_json

    # Expectations
    connection.expects(:write).with(expected_payload)
    Rails.logger.expects(:info).with("Sent message to external WebSocket: #{expected_payload}")

    # Action
    @channel.send(:send_to_external_application, message)
  end

  test "send_to_external_application handles missing connection" do
    # Setup
    @channel = subscribe
    @channel.instance_variable_set(:@external_ws_connection, nil)
    
    message = { "message" => "Hello" }

    # Expectations
    Rails.logger.expects(:error).with("External WebSocket connection not established")

    # Action
    @channel.send(:send_to_external_application, message)
  end

  test "send_to_external_application handles write errors" do
    # Setup
    connection = stub('websocket_connection')
    @channel = subscribe
    @channel.instance_variable_set(:@external_ws_connection, connection)
    
    message = { "message" => "Hello" }
    expected_payload = message.to_json

    # Expectations
    connection.expects(:write).with(expected_payload).raises(StandardError.new("Connection failed"))
    Rails.logger.expects(:error).with("Error sending message to external WebSocket: Connection failed")

    # Action
    @channel.send(:send_to_external_application, message)
  end

  test "adds message to ChatMessage when sending to external application" do
    # Subscribe to the channel
    subscribe session_id: "test_session"

    # Initial message count
    initial_count = ChatMessage.count

    # Simulate sending a message
    message_data = {
      "message" => "Hello AI",
      "context" => "pages/show",
      "webPageId" => @page.id.to_s
    }

    # Assert that a new ChatMessage is created when sending
    assert_difference -> { ChatMessage.count }, 1 do
      perform :receive, message_data
    end

    # Verify the created message
    new_message = ChatMessage.last
    assert_equal "Hello AI", new_message.content
    assert_equal @user, new_message.user
    assert_equal false, new_message.ai_chat_message
    assert_not_nil new_message.chat_conversation
  end

  test "adds message to ChatMessage when receiving from external application" do
    subscribe session_id: "test_session"
    
    # Initial message count
    initial_count = ChatMessage.count

    # Simulate receiving a message from external websocket
    external_message = {
      "type" => "chat_response",
      "content" => "AI response message"
    }.to_json

    # Create a stubbed connection with Mocha
    connection = stub('websocket_connection')
    connection.expects(:read).returns(external_message)

    # Assert that a new ChatMessage is created when receiving
    assert_difference -> { ChatMessage.count }, 1 do
      # Call the listen method directly with our stubbed connection
      @channel.send(:listen_to_external_websocket, connection)
    end

    # Verify the created message
    new_message = ChatMessage.last
    assert_equal "AI response message", new_message.content
    assert_equal @user, new_message.user
    assert_equal true, new_message.ai_chat_message
    assert_equal @chat_conversation, new_message.chat_conversation
  end
end
