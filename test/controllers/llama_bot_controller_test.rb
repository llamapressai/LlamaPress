require 'test_helper'

class LlamaBotControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  
  setup do
    @page = pages(:one)
    @user = users(:one)
    sign_in @user
  end

  test "should get get_message_history_from_llamabot_checkpoint" do
    LlamaBot.expects(:get_message_history_from_llamabot_checkpoint).with(@page.id.to_s).returns({ "choices" => [] })
    get llama_bot_get_message_history_from_llamabot_checkpoint_url(page_id: @page.id)
    assert_response :success
  end
end