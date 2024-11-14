require "test_helper"

class ChatConversationTest < ActiveSupport::TestCase
  test "should create uuid on create" do
    chat_conversation = ChatConversation.create(user: users(:one), page: pages(:one))
    assert_not_nil chat_conversation.uuid
  end
end
