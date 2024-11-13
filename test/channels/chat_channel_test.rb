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

  test "receive_from_external_application" do
    #TODO: create this test before implementing in ChatChannel (test driven development)

  end

  test "adds message to ChatMessage on both sent and received" do
    #TODO: create this test before implementing in ChatChannel (test driven development)

  end
end
