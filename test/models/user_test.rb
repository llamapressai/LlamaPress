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

  test "should_we_allow_user_to_send_this_message? returns true if user has less than 6 messages today" do
    user = users(:one)
    user.subscription_plan = nil  # Ensure no subscription
    
    # Create 5 messages for today
    5.times do
      user.chat_messages.create(sender: :human_message, created_at: Date.today)
    end
    
    assert user.should_we_allow_user_to_send_this_message?
  end

  test "should_we_allow_user_to_send_this_message? returns false if user has 6 or more messages today and no subscription" do
    user = users(:one)
    user.subscription_plan = nil  # Ensure no subscription
    
    assert_difference 'user.today_message_count', 6 do
      # Create 6 messages for today
      chat_conversation = user.chat_conversations.create!
      6.times do
        user.chat_messages.create!(content: "test", sender: :human_message, created_at: Date.today, chat_conversation: chat_conversation)
      end
    end
    
    # byebug
    refute user.should_we_allow_user_to_send_this_message?
  end

  test "today_message_count only counts messages from today" do
    user = users(:one)
    
    chat_conversation = user.chat_conversations.create!
    
    assert_difference 'user.chat_messages.count', 3 do
      # Create messages from yesterday
      3.times do
        user.chat_messages.create!(content: "test", sender: :human_message, created_at: Date.yesterday, chat_conversation: chat_conversation)
      end
    end
    
    # Create messages from today
    assert_difference 'user.today_message_count', 2 do
      2.times do
        user.chat_messages.create!(content: "test", sender: :human_message, created_at: Date.today, chat_conversation: chat_conversation)
      end
    end
    
    assert_equal 2, user.today_message_count
  end

  test "today_message_count only counts human messages" do
    user = users(:one)
    chat_conversation = user.chat_conversations.create!
    
    # Create human messages
    2.times do
      user.chat_messages.create!(content: "test", sender: :human_message, created_at: Date.today, chat_conversation: chat_conversation)
    end
    
    # Create AI messages
    3.times do
      user.chat_messages.create!(content: "test", sender: :ai_message, created_at: Date.today, chat_conversation: chat_conversation)
    end
    
    assert_equal 2, user.today_message_count
  end
end
