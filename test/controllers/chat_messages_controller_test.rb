require "test_helper"

class ChatMessagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @chat_message = chat_messages(:one)
  end

  test "should get index" do
    get chat_messages_url
    assert_response :success
  end

  test "should get new" do
    get new_chat_message_url
    assert_response :success
  end

  test "should create chat_message" do
    assert_difference("ChatMessage.count") do
      post chat_messages_url, params: { chat_message: { chat_conversation_id: @chat_message.chat_conversation_id, content: @chat_message.content, sender: @chat_message.sender, site_id: @chat_message.site_id, user_id: @chat_message.user_id, uuid: @chat_message.uuid } }
    end

    assert_redirected_to chat_message_url(ChatMessage.last)
  end

  test "should show chat_message" do
    get chat_message_url(@chat_message)
    assert_response :success
  end

  test "should get edit" do
    get edit_chat_message_url(@chat_message)
    assert_response :success
  end

  test "should update chat_message" do
    patch chat_message_url(@chat_message), params: { chat_message: { chat_conversation_id: @chat_message.chat_conversation_id, content: @chat_message.content, sender: @chat_message.sender, site_id: @chat_message.site_id, user_id: @chat_message.user_id, uuid: @chat_message.uuid } }
    assert_redirected_to chat_message_url(@chat_message)
  end

  test "should destroy chat_message" do
    assert_difference("ChatMessage.count", -1) do
      delete chat_message_url(@chat_message)
    end

    assert_redirected_to chat_messages_url
  end
end
