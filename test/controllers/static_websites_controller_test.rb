require "test_helper"

class StaticWebsitesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @static_website = static_websites(:one)
  end

  test "should get index" do
    get static_websites_url
    assert_response :success
  end

  test "should get new" do
    get new_static_website_url
    assert_response :success
  end

  test "should create static_website" do
    assert_difference("StaticWebsite.count") do
      post static_websites_url, params: { static_website: { name: @static_website.name, organization_id: @static_website.organization_id, slug: @static_website.slug } }
    end

    assert_redirected_to static_website_url(StaticWebsite.last)
  end

  test "should show static_website" do
    get static_website_url(@static_website)
    assert_response :success
  end

  test "should get edit" do
    get edit_static_website_url(@static_website)
    assert_response :success
  end

  test "should update static_website" do
    patch static_website_url(@static_website), params: { static_website: { name: @static_website.name, organization_id: @static_website.organization_id, slug: @static_website.slug } }
    assert_redirected_to static_website_url(@static_website)
  end

  test "should destroy static_website" do
    assert_difference("StaticWebsite.count", -1) do
      delete static_website_url(@static_website)
    end

    assert_redirected_to static_websites_url
  end
end
