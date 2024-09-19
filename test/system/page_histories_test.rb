require "application_system_test_case"

class PageHistoriesTest < ApplicationSystemTestCase
  setup do
    @page_history = page_histories(:one)
  end

  test "visiting the index" do
    visit page_histories_url
    assert_selector "h1", text: "web page histories"
  end

  test "should create web page history" do
    visit page_histories_url
    click_on "New web page history"

    fill_in "Content", with: @page_history.content
    fill_in "Prompt", with: @page_history.prompt
    fill_in "web page", with: @page_history.page_id
    fill_in "User message", with: @page_history.user_message
    click_on "Create web page history"

    assert_text "web page history was successfully created"
    click_on "Back"
  end

  test "should update web page history" do
    visit page_history_url(@page_history)
    click_on "Edit this web page history", match: :first

    fill_in "Content", with: @page_history.content
    fill_in "Prompt", with: @page_history.prompt
    fill_in "web page", with: @page_history.page_id
    fill_in "User message", with: @page_history.user_message
    click_on "Update web page history"

    assert_text "web page history was successfully updated"
    click_on "Back"
  end

  test "should destroy web page history" do
    visit page_history_url(@page_history)
    click_on "Destroy this web page history", match: :first

    assert_text "web page history was successfully destroyed"
  end
end
