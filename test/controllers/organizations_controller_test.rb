# require "test_helper"

# class OrganizationsControllerTest < ActionDispatch::IntegrationTest
#   include Devise::Test::IntegrationHelpers
#   setup do
#     @user = users(:one)
#     sign_in @user
#     @organization = organizations(:one)
#   end

#   test "should get index" do
#     get organizations_url
#     assert_response :success
#   end

#   test "should get new" do
#     get new_organization_url
#     assert_response :success
#   end

#   test "should create organization" do
#     assert_difference("Organization.count") do
#       post organizations_url, params: { organization: { city: @organization.city, email: @organization.email, name: @organization.name, notes: @organization.notes, phone: @organization.phone, state: @organization.state, street_address: @organization.street_address, zip_code: @organization.zip_code } }
#     end

#     assert_redirected_to organization_url(Organization.last)
#   end

#   test "should show organization" do
#     get organization_url(@organization)
#     assert_response :success
#   end

#   test "should get edit" do
#     get edit_organization_url(@organization)
#     assert_response :success
#   end

#   test "should update organization" do
#     patch organization_url(@organization), params: { organization: { city: @organization.city, email: @organization.email, name: @organization.name, notes: @organization.notes, phone: @organization.phone, state: @organization.state, street_address: @organization.street_address, zip_code: @organization.zip_code } }
#     assert_redirected_to organization_url(@organization)
#   end

#   test "should destroy organization" do
#     assert_difference("Organization.count", -1) do
#       delete organization_url(@organization)
#     end

#     assert_redirected_to organizations_url
#   end
# end
