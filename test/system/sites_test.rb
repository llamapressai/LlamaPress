require "application_system_test_case"

class SitesTest < ApplicationSystemTestCase
  setup do
    @site = sites(:one)
  end

  test "visiting the index" do
    visit sites_url
    assert_selector "h1", text: "web sites"
  end

  test "should create web site" do
    visit sites_url
    click_on "New web site"

    fill_in "Name", with: @site.name
    fill_in "Organization", with: @site.organization_id
    fill_in "Slug", with: @site.slug
    click_on "Create web site"

    assert_text "web site was successfully created"
    click_on "Back"
  end

  test "should update web site" do
    visit site_url(@site)
    click_on "Edit this web site", match: :first

    fill_in "Name", with: @site.name
    fill_in "Organization", with: @site.organization_id
    fill_in "Slug", with: @site.slug
    click_on "Update web site"

    assert_text "web site was successfully updated"
    click_on "Back"
  end

  test "should destroy web site" do
    visit site_url(@site)
    click_on "Destroy this web site", match: :first

    assert_text "web site was successfully destroyed"
  end
end
