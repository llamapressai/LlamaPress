require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "today_message_count returns 0 since chat system was removed" do
    user = users(:one)
    
    # Chat system was removed, so this should always return 0
    assert_equal 0, user.today_message_count
  end

  test "today_message_count returns 0 for all users since chat system was removed" do
    user = users(:one)
    
    # Chat system was removed, so this should always return 0
    assert_equal 0, user.today_message_count
  end
end
