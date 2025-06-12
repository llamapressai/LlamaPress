require "application_system_test_case"

class ChatFrontendLlamaBotTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers
  include ActionCable::TestHelper

  setup do
    @user = users(:one)
    @page = pages(:one)
    sign_in @user
    
    # Set up a predictable session ID for testing
    # hardcoded in PagesController.get_session_id_for_websocket_chat_channel() for test environmen
    @session_id = "test_session_123" 
  end

  ##Sends an external_ws_pong message to Javascript websocket to simulate the pong connect.
  # This turns the connection green, and also should enable the user to send messages properly.
  def mock_pong_from_llamabot_backend
    formatted_message = { message: {type: "external_ws_pong"} }.to_json
    ActionCable.server.broadcast(
      "chat_channel_#{@session_id}",
      formatted_message
    )
  end

  test "should send message to llama bot with thinking message" do
    visit page_url(@page)
    
    mock_pong_from_llamabot_backend
    sleep(2) #give time for the connection to be established
    
    # Check connection status using JavaScript
    connection_status = evaluate_script("document.querySelector('#connectionStatusIconForLlamaBot').classList.contains('bg-green-500')")
    assert connection_status, "Expected connection status to be green"

    find("textarea[id='userInput']").fill_in with: "Hello"    
    click_on "Send"
    assert_text "Thinking.."
  end

  test "should send message to llama bot with chat_message parameter" do
    skip "This test is broken, chat_message params don't appear to be passing through the webpage properly."
    visit page_url(@page, chat_message: "Hello")
    assert_text "Hello"
    assert_text "Thinking.."
  end

  test "shouldn't send message if not connected to chatchannel yet.. yellow or red indicator" do
    skip "Need to implement this functionality to not send"
    visit page_url(@page)
    find("textarea[id='userInput']").fill_in with: "Hello"
    click_on "Send"
    assert_text "Waiting to send.."
  end

  test "loading llamabot with red message displays an error" do
    skip "Test is failing due to visibility issues with Connection Error modal"
    visit page_url(@page)

    # wait for the loading indicator to appear
    sleep 22
    
    #TODO: This test is failing for some reason, even though the modal is appearing.
    assert_text "Connection Error"

    ##Error Message: Expected to find text "Connection Error" ... (However, it was found 2 times including non-visible text.)
  end
end