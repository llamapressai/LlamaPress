require "application_system_test_case"

class StaticWebPageHistoriesTest < ApplicationSystemTestCase
  setup do
    @static_web_page_history = static_web_page_histories(:one)
  end

  test "visiting the index" do
    visit static_web_page_histories_url
    assert_selector "h1", text: "Static web page histories"
  end

  test "should create static web page history" do
    visit static_web_page_histories_url
    click_on "New static web page history"

    fill_in "Content", with: @static_web_page_history.content
    fill_in "Prompt", with: @static_web_page_history.prompt
    fill_in "Static web page", with: @static_web_page_history.static_web_page_id
    fill_in "User message", with: @static_web_page_history.user_message
    click_on "Create Static web page history"

    assert_text "Static web page history was successfully created"
    click_on "Back"
  end

  test "should update Static web page history" do
    visit static_web_page_history_url(@static_web_page_history)
    click_on "Edit this static web page history", match: :first

    fill_in "Content", with: @static_web_page_history.content
    fill_in "Prompt", with: @static_web_page_history.prompt
    fill_in "Static web page", with: @static_web_page_history.static_web_page_id
    fill_in "User message", with: @static_web_page_history.user_message
    click_on "Update Static web page history"

    assert_text "Static web page history was successfully updated"
    click_on "Back"
  end

  test "should destroy Static web page history" do
    visit static_web_page_history_url(@static_web_page_history)
    click_on "Destroy this static web page history", match: :first

    assert_text "Static web page history was successfully destroyed"
  end
end
