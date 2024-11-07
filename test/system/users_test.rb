require "application_system_test_case"

class UsersTest < ApplicationSystemTestCase
  setup do
    @user = users(:one)
  end

  test "should register user" do
    visit "/users/sign_up"
    fill_in "Email", with: "test@test.com"
    fill_in "Password", with: "1234567890"
    fill_in "Password confirmation", with: "1234567890"
    click_on "Sign up"
    assert_text "Welcome"
  end

  test "should login user" do
    @user.password = "1234567890"
    @user.save
    visit "/users/sign_in"
    fill_in "Email", with: @user.email
    fill_in "Password", with: "1234567890"
    click_on "Log in"
    assert_text "What do you want to change?"
  end
end