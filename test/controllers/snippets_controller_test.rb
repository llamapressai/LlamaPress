# require "test_helper"

# class SnippetsControllerTest < ActionDispatch::IntegrationTest
#   setup do
#     @snippet = snippets(:one)
#   end

#   test "should get index" do
#     get snippets_url
#     assert_response :success
#   end

#   test "should get new" do
#     get new_snippet_url
#     assert_response :success
#   end

#   test "should create snippet" do
#     assert_difference("Snippet.count") do
#       post snippets_url, params: { snippet: { content: @snippet.content, name: @snippet.name, site_id: @snippet.site_id } }
#     end

#     assert_redirected_to snippet_url(Snippet.last)
#   end

#   test "should show snippet" do
#     get snippet_url(@snippet)
#     assert_response :success
#   end

#   test "should get edit" do
#     get edit_snippet_url(@snippet)
#     assert_response :success
#   end

#   test "should update snippet" do
#     patch snippet_url(@snippet), params: { snippet: { content: @snippet.content, name: @snippet.name, site_id: @snippet.site_id } }
#     assert_redirected_to snippet_url(@snippet)
#   end

#   test "should destroy snippet" do
#     assert_difference("Snippet.count", -1) do
#       delete snippet_url(@snippet)
#     end

#     assert_redirected_to snippets_url
#   end
# end
