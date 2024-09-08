require "application_system_test_case"

class StaticWebSitesTest < ApplicationSystemTestCase
  setup do
    @static_web_site = static_web_sites(:one)
  end

  test "visiting the index" do
    visit static_web_sites_url
    assert_selector "h1", text: "Static web sites"
  end

  test "should create static web site" do
    visit static_web_sites_url
    click_on "New static web site"

    fill_in "Name", with: @static_web_site.name
    fill_in "Organization", with: @static_web_site.organization_id
    fill_in "Slug", with: @static_web_site.slug
    click_on "Create Static web site"

    assert_text "Static web site was successfully created"
    click_on "Back"
  end

  test "should update Static web site" do
    visit static_web_site_url(@static_web_site)
    click_on "Edit this static web site", match: :first

    fill_in "Name", with: @static_web_site.name
    fill_in "Organization", with: @static_web_site.organization_id
    fill_in "Slug", with: @static_web_site.slug
    click_on "Update Static web site"

    assert_text "Static web site was successfully updated"
    click_on "Back"
  end

  test "should destroy Static web site" do
    visit static_web_site_url(@static_web_site)
    click_on "Destroy this static web site", match: :first

    assert_text "Static web site was successfully destroyed"
  end
end
