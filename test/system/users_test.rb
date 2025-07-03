require "application_system_test_case"

class UsersTest < ApplicationSystemTestCase
  setup do
    @user = users(:one)
  end

  test "should register user" do
    visit "/users/sign_up"
    fill_in "Email address", with: "test@test.com"
    fill_in "Organization name", with: "Test Organization"
    fill_in "Password", with: "1234567890"
    fill_in "Confirm password", with: "1234567890"
    click_on "Sign up"
    assert_text "Welcome! You have signed up successfully"
  end

  test "should login user" do
    @user.password = "1234567890"
    @user.save
    visit "/users/sign_in"
    fill_in "Email", with: @user.email
    fill_in "Password", with: "1234567890"
    click_on "Log in"
    assert_text "Signed in successfully"
  end
end