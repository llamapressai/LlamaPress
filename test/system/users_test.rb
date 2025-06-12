require "application_system_test_case"

class UsersTest < ApplicationSystemTestCase
  setup do
    @user = users(:one)
  end

  test "should register user" do
    visit "/users/sign_up"
    fill_in id: "website-prompt", with: "I want a website for my coffee shop"
    click_on "Generate your website"
    fill_in "Email", with: "test@test.com"
    fill_in "Password", with: "1234567890"
    # fill_in "Password confirmation", with: "1234567890"
    click_on "Create my website"
    assert_text "LlamaBot"
    assert_text "What do you want to change?"
     #assert that the chat_message comes through and gets sent to the llama bot
     sleep(2)
     assert_text "I want a website for my coffee shop"
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