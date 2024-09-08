require "application_system_test_case"

class StaticWebPagesTest < ApplicationSystemTestCase
  setup do
    @static_web_page = static_web_pages(:one)
  end

  test "visiting the index" do
    visit static_web_pages_url
    assert_selector "h1", text: "Static web pages"
  end

  test "should create static web page" do
    visit static_web_pages_url
    click_on "New static web page"

    fill_in "Content", with: @static_web_page.content
    fill_in "Prompt", with: @static_web_page.prompt
    fill_in "Slug", with: @static_web_page.slug
    fill_in "Static web site", with: @static_web_page.static_web_site_id
    click_on "Create Static web page"

    assert_text "Static web page was successfully created"
    click_on "Back"
  end

  test "should update Static web page" do
    visit static_web_page_url(@static_web_page)
    click_on "Edit this static web page", match: :first

    fill_in "Content", with: @static_web_page.content
    fill_in "Prompt", with: @static_web_page.prompt
    fill_in "Slug", with: @static_web_page.slug
    fill_in "Static web site", with: @static_web_page.static_web_site_id
    click_on "Update Static web page"

    assert_text "Static web page was successfully updated"
    click_on "Back"
  end

  test "should destroy Static web page" do
    visit static_web_page_url(@static_web_page)
    click_on "Destroy this static web page", match: :first

    assert_text "Static web page was successfully destroyed"
  end
end
