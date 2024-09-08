require "test_helper"

class StaticWebPageHistoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @static_web_page_history = static_web_page_histories(:one)
  end

  test "should get index" do
    get static_web_page_histories_url
    assert_response :success
  end

  test "should get new" do
    get new_static_web_page_history_url
    assert_response :success
  end

  test "should create static_web_page_history" do
    assert_difference("StaticWebPageHistory.count") do
      post static_web_page_histories_url, params: { static_web_page_history: { content: @static_web_page_history.content, prompt: @static_web_page_history.prompt, static_web_page_id: @static_web_page_history.static_web_page_id, user_message: @static_web_page_history.user_message } }
    end

    assert_redirected_to static_web_page_history_url(StaticWebPageHistory.last)
  end

  test "should show static_web_page_history" do
    get static_web_page_history_url(@static_web_page_history)
    assert_response :success
  end

  test "should get edit" do
    get edit_static_web_page_history_url(@static_web_page_history)
    assert_response :success
  end

  test "should update static_web_page_history" do
    patch static_web_page_history_url(@static_web_page_history), params: { static_web_page_history: { content: @static_web_page_history.content, prompt: @static_web_page_history.prompt, static_web_page_id: @static_web_page_history.static_web_page_id, user_message: @static_web_page_history.user_message } }
    assert_redirected_to static_web_page_history_url(@static_web_page_history)
  end

  test "should destroy static_web_page_history" do
    assert_difference("StaticWebPageHistory.count", -1) do
      delete static_web_page_history_url(@static_web_page_history)
    end

    assert_redirected_to static_web_page_histories_url
  end
end
