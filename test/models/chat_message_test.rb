# require "test_helper"

# class ChatMessageTest < ActiveSupport::TestCase
#   def setup
#     @chat_message = chat_messages(:one)
#   end

#   test "valid chat message" do
#     assert @chat_message.valid?
#   end

#   test "should belong to user" do
#     assert_respond_to @chat_message, :user
#     assert_instance_of User, @chat_message.user
#   end

#   test "should belong to chat conversation" do
#     assert_respond_to @chat_message, :chat_conversation
#     assert_instance_of ChatConversation, @chat_message.chat_conversation
#   end

#   test "should belong to site" do
#     assert_respond_to @chat_message, :site
#     assert_instance_of Site, @chat_message.site
#   end

#   test "should validate presence of content" do
#     @chat_message.content = nil
#     assert_not @chat_message.valid?
#     assert_includes @chat_message.errors[:content], "can't be blank"
#   end

#   test "should validate presence of sender" do
#     @chat_message.sender = nil
#     assert_not @chat_message.valid?
#     assert_includes @chat_message.errors[:sender], "can't be blank"
#   end

#   test "should validate presence of uuid" do
#     @chat_message.uuid = nil
#     assert_not @chat_message.valid?
#     assert_includes @chat_message.errors[:uuid], "can't be blank"
#   end

#   test "should validate uniqueness of uuid" do
#     duplicate_message = @chat_message.dup
#     duplicate_message.uuid = @chat_message.uuid
#     assert_not duplicate_message.valid?
#     assert_includes duplicate_message.errors[:uuid], "has already been taken"
#   end

#   test "should have valid enum values for sender" do
#     assert_includes ChatMessage.senders.keys, "human_message"
#     assert_includes ChatMessage.senders.keys, "ai_message"
#   end

#   test "should automatically generate uuid on create" do
#     new_message = ChatMessage.new(
#       content: "Test message",
#       sender: :human_message,
#       user: users(:one),
#       chat_conversation: chat_conversations(:one),
#       site: sites(:one)
#     )
#     assert_nil new_message.uuid
#     assert new_message.save
#     assert_match(/^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/, new_message.uuid)
#   end
# end