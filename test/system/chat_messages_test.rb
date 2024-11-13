require "application_system_test_case"

class ChatMessagesTest < ApplicationSystemTestCase
  setup do
    @chat_message = chat_messages(:one)
  end

  test "visiting the index" do
    visit chat_messages_url
    assert_selector "h1", text: "Chat messages"
  end

  test "should create chat message" do
    visit chat_messages_url
    click_on "New chat message"

    fill_in "Chat conversation", with: @chat_message.chat_conversation_id
    fill_in "Content", with: @chat_message.content
    fill_in "Sender", with: @chat_message.sender
    fill_in "Site", with: @chat_message.site_id
    fill_in "User", with: @chat_message.user_id
    fill_in "Uuid", with: @chat_message.uuid
    click_on "Create Chat message"

    assert_text "Chat message was successfully created"
    click_on "Back"
  end

  test "should update Chat message" do
    visit chat_message_url(@chat_message)
    click_on "Edit this chat message", match: :first

    fill_in "Chat conversation", with: @chat_message.chat_conversation_id
    fill_in "Content", with: @chat_message.content
    fill_in "Sender", with: @chat_message.sender
    fill_in "Site", with: @chat_message.site_id
    fill_in "User", with: @chat_message.user_id
    fill_in "Uuid", with: @chat_message.uuid
    click_on "Update Chat message"

    assert_text "Chat message was successfully updated"
    click_on "Back"
  end

  test "should destroy Chat message" do
    visit chat_message_url(@chat_message)
    click_on "Destroy this chat message", match: :first

    assert_text "Chat message was successfully destroyed"
  end
end
