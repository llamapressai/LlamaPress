require "application_system_test_case"

class PagesTest < ApplicationSystemTestCase
  setup do
    @page = pages(:one)
  end

  test "visiting the index" do
    visit pages_url
    assert_selector "h1", text: "web pages"
  end

  test "should create web page" do
    visit pages_url
    click_on "New web page"

    fill_in "Content", with: @page.content
    fill_in "Prompt", with: @page.prompt
    fill_in "Slug", with: @page.slug
    fill_in "web site", with: @page.site_id
    click_on "Create web page"

    assert_text "web page was successfully created"
    click_on "Back"
  end

  test "should update web page" do
    visit page_url(@page)
    click_on "Edit this web page", match: :first

    fill_in "Content", with: @page.content
    fill_in "Prompt", with: @page.prompt
    fill_in "Slug", with: @page.slug
    fill_in "web site", with: @page.site_id
    click_on "Update web page"

    assert_text "web page was successfully updated"
    click_on "Back"
  end

  test "should destroy web page" do
    visit page_url(@page)
    click_on "Destroy this web page", match: :first

    assert_text "web page was successfully destroyed"
  end
end
