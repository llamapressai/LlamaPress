require "application_system_test_case"

class StaticWebsitesTest < ApplicationSystemTestCase
  setup do
    @static_website = static_websites(:one)
  end

  test "visiting the index" do
    visit static_websites_url
    assert_selector "h1", text: "Static websites"
  end

  test "should create static website" do
    visit static_websites_url
    click_on "New static website"

    fill_in "Name", with: @static_website.name
    fill_in "Organization", with: @static_website.organization_id
    fill_in "Slug", with: @static_website.slug
    click_on "Create Static website"

    assert_text "Static website was successfully created"
    click_on "Back"
  end

  test "should update Static website" do
    visit static_website_url(@static_website)
    click_on "Edit this static website", match: :first

    fill_in "Name", with: @static_website.name
    fill_in "Organization", with: @static_website.organization_id
    fill_in "Slug", with: @static_website.slug
    click_on "Update Static website"

    assert_text "Static website was successfully updated"
    click_on "Back"
  end

  test "should destroy Static website" do
    visit static_website_url(@static_website)
    click_on "Destroy this static website", match: :first

    assert_text "Static website was successfully destroyed"
  end
end
