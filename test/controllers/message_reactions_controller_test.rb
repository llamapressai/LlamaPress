require "test_helper"

class MessageReactionsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  setup do
    @user = users(:one)
    @page_history = page_histories(:one)
    sign_in @user
  end

  test "should create a new reaction" do
    assert_difference("MessageReaction.count", 1) do
      post "/message_reactions", params: { 
        message_reaction: {
          page_history_id: @page_history.id, 
          reaction_type: "up",
          feedback: "Great answer!" 
        }
      }, as: :json
      
      assert_response :success
      json_response = JSON.parse(response.body)
      assert_equal "success", json_response["status"]
      assert_equal "up", json_response["reaction_type"]
      assert_equal "Great answer!", json_response["feedback"]
    end
  end

end
