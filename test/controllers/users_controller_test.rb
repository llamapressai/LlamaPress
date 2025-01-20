# require "test_helper"

# class UsersControllerTest < ActionDispatch::IntegrationTest
#   include Devise::Test::IntegrationHelpers
#   setup do
#     @user = users(:one)
#     sign_in @user
#   end

#   test "should get index" do
#     get users_url
#     assert_response :success
#   end

#   test "should get new" do
#     get new_user_url
#     assert_response :success
#   end

#   test "should create user" do
#     assert_difference("User.count") do
#       post users_url, params: { user: { email: "test1@email.com", first_name: "test1", last_name: "test1", organization_id: @user.organization_id, phone: "1234567890", password: "123456" } }
#     end

#     assert_response :success
#   end

#   test "should show user" do
#     get user_url(@user)
#     assert_response :success
#   end

#   test "should get edit" do
#     get edit_user_url(@user)
#     assert_response :success
#   end

#   test "should update user" do
#     patch user_url(@user), params: { user: { email: @user.email, first_name: @user.first_name, last_name: @user.last_name, organization_id: @user.organization_id, phone: @user.phone } }
#     assert_redirected_to user_url(@user)
#   end

#   test "should destroy user" do
#     assert_difference("User.count", -1) do
#       delete user_url(@user)
#     end

#     assert_redirected_to users_url
#   end
# end
