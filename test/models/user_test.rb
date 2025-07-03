require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "valid_subscription? returns true if user has a subscription plan" do
    user = users(:one)
    assert user.valid_subscription?
  end

  test "valid_subscription? returns false if user has no subscription plan" do
    user = users(:two)
    assert_not user.valid_subscription?
  end

  test "should_we_allow_user_to_send_this_message? returns true if user has a valid subscription plan" do
    user = users(:one)
    user.subscription_plan = "basic"  # Set a subscription plan
    
    assert user.should_we_allow_user_to_send_this_message?
  end

  test "should_we_allow_user_to_send_this_message? returns true if user has less than 15 messages today" do
    user = users(:one)
    user.subscription_plan = nil  # Ensure no subscription
    
    # Since today_message_count now returns 0 (chat system removed), user should be allowed
    assert user.should_we_allow_user_to_send_this_message?
  end

  test "should_we_allow_user_to_send_this_message? returns true since chat system was removed" do
    user = users(:one)
    user.subscription_plan = nil  # Ensure no subscription
    
    # Since today_message_count now returns 0, user should always be allowed
    assert user.should_we_allow_user_to_send_this_message?
  end

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
