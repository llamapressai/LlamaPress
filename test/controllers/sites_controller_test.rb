require "test_helper"

class SitesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  setup do
    @user = users(:one)
    sign_in @user
    @site = sites(:one)
  end

  test "should get index" do
    get sites_url
    assert_response :success
  end

  test "should get new" do
    get new_site_url
    assert_response :success
  end

  test "should create site" do
    assert_difference("Site.count") do
      post sites_url, params: { site: { name: @site.name, organization_id: @site.organization_id, slug: "@site.slug#{Time.now.to_i}" } }
    end

    assert_redirected_to site_url(Site.last)
  end

  test "should show site" do
    get site_url(@site)
    assert_response :success
  end

  test "should get edit" do
    get edit_site_url(@site)
    assert_response :success
  end

  test "should update site" do
    patch site_url(@site), params: { site: { name: @site.name, organization_id: @site.organization_id, slug: "@site.slug#{Time.now.to_i}" } }
    assert_redirected_to site_url(@site)
  end

  test "should destroy site" do
    assert_difference("Site.count", -1) do
      delete site_url(@site)
    end

    assert_redirected_to sites_url
  end

  test "should get current_site from application controller" do
    # Clear any existing OVERRIDE_DOMAIN setting
    ENV.delete("OVERRIDE_DOMAIN")
    
    # Create a web site with a known slug
    site = Site.create!(name: "Test Site", slug: "example.com", organization: organizations(:one))

    users(:one).default_site = site
    users(:one).save
    
    # Set the host explicitly for this request
    host! "example.com"
        
    # Make a request to any action in the controller
    get sites_url
    
    # Assert that the current_site is set correctly
    assert_equal site, @controller.current_site
  ensure
    # Clean up environment
    ENV.delete("OVERRIDE_DOMAIN")
  end
end