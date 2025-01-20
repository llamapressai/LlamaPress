# require "test_helper"

# class PageHistoriesControllerTest < ActionDispatch::IntegrationTest
#   include Devise::Test::IntegrationHelpers
#   setup do
#     @user = users(:one)
#     sign_in @user
#     @page_history = page_histories(:one)
#   end

#   test "should get index" do
#     get page_histories_url
#     assert_response :success
#   end

#   test "should get new" do
#     get new_page_history_url
#     assert_response :success
#   end

#   test "should create page_history" do
#     assert_difference("PageHistory.count") do
#       post page_histories_url, params: { page_history: { content: @page_history.content, prompt: @page_history.prompt, page_id: @page_history.page_id, user_message: @page_history.user_message } }
#     end

#     assert_redirected_to page_history_url(PageHistory.last)
#   end

#   test "should show page_history" do
#     get page_history_url(@page_history)
#     assert_response :success
#   end

#   test "should get edit" do
#     get edit_page_history_url(@page_history)
#     assert_response :success
#   end

#   test "should update page_history" do
#     patch page_history_url(@page_history), params: { page_history: { content: @page_history.content, prompt: @page_history.prompt, page_id: @page_history.page_id, user_message: @page_history.user_message } }
#     assert_redirected_to page_history_url(@page_history)
#   end

#   test "should destroy page_history" do
#     assert_difference("PageHistory.count", -1) do
#       delete page_history_url(@page_history)
#     end

#     assert_redirected_to page_histories_url
#   end
# end
