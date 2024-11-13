require "test_helper"

class ChatConversationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @chat_conversation = chat_conversations(:one)
  end

  test "should get index" do
    get chat_conversations_url
    assert_response :success
  end

  test "should get new" do
    get new_chat_conversation_url
    assert_response :success
  end

  test "should create chat_conversation" do
    assert_difference("ChatConversation.count") do
      post chat_conversations_url, params: { chat_conversation: { site_id: @chat_conversation.site_id, title: @chat_conversation.title, user_id: @chat_conversation.user_id, uuid: @chat_conversation.uuid } }
    end

    assert_redirected_to chat_conversation_url(ChatConversation.last)
  end

  test "should show chat_conversation" do
    get chat_conversation_url(@chat_conversation)
    assert_response :success
  end

  test "should get edit" do
    get edit_chat_conversation_url(@chat_conversation)
    assert_response :success
  end

  test "should update chat_conversation" do
    patch chat_conversation_url(@chat_conversation), params: { chat_conversation: { site_id: @chat_conversation.site_id, title: @chat_conversation.title, user_id: @chat_conversation.user_id, uuid: @chat_conversation.uuid } }
    assert_redirected_to chat_conversation_url(@chat_conversation)
  end

  test "should destroy chat_conversation" do
    assert_difference("ChatConversation.count", -1) do
      delete chat_conversation_url(@chat_conversation)
    end

    assert_redirected_to chat_conversations_url
  end
end
