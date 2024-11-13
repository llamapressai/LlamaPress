require "application_system_test_case"

class ChatConversationsTest < ApplicationSystemTestCase
  setup do
    @chat_conversation = chat_conversations(:one)
  end

  test "visiting the index" do
    visit chat_conversations_url
    assert_selector "h1", text: "Chat conversations"
  end

  test "should create chat conversation" do
    visit chat_conversations_url
    click_on "New chat conversation"

    fill_in "Site", with: @chat_conversation.site_id
    fill_in "Title", with: @chat_conversation.title
    fill_in "User", with: @chat_conversation.user_id
    fill_in "Uuid", with: @chat_conversation.uuid
    click_on "Create Chat conversation"

    assert_text "Chat conversation was successfully created"
    click_on "Back"
  end

  test "should update Chat conversation" do
    visit chat_conversation_url(@chat_conversation)
    click_on "Edit this chat conversation", match: :first

    fill_in "Site", with: @chat_conversation.site_id
    fill_in "Title", with: @chat_conversation.title
    fill_in "User", with: @chat_conversation.user_id
    fill_in "Uuid", with: @chat_conversation.uuid
    click_on "Update Chat conversation"

    assert_text "Chat conversation was successfully updated"
    click_on "Back"
  end

  test "should destroy Chat conversation" do
    visit chat_conversation_url(@chat_conversation)
    click_on "Destroy this chat conversation", match: :first

    assert_text "Chat conversation was successfully destroyed"
  end
end
