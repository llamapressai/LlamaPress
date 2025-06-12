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

  test "should destroy site and nullify home_page and after_submission_page references" do
    # Create pages that will be referenced
    home_page = Page.create!(
      content: "<html><body>Home Page</body></html>",
      slug: "home-page-#{Time.now.to_i}",
      site: @site,
      organization: @user.organization
    )
    
    after_submission_page = Page.create!(
      content: "<html><body>Thank You Page</body></html>",
      slug: "thank-you-page-#{Time.now.to_i}",
      site: @site,
      organization: @user.organization
    )
    
    # Set up the references
    @site.update!(
      home_page_id: home_page.id,
      after_submission_page_id: after_submission_page.id
    )
    
    # Store the page IDs for later verification
    home_page_id = home_page.id
    after_submission_page_id = after_submission_page.id
    
    # Verify the setup
    assert_equal home_page.id, @site.home_page_id
    assert_equal after_submission_page.id, @site.after_submission_page_id
    
    # Perform the deletion and verify all associated records are deleted
    assert_difference("Site.count", -1) do
      assert_difference("Page.count", -3) do  # Both pages should be deleted, plus the default page
        delete site_url(@site)
      end
    end
    
    # Verify the site was deleted
    assert_redirected_to "/"
    assert_raises(ActiveRecord::RecordNotFound) { @site.reload }
    
    # Verify the pages were also deleted
    assert_raises(ActiveRecord::RecordNotFound) { Page.find(home_page_id) }
    assert_raises(ActiveRecord::RecordNotFound) { Page.find(after_submission_page_id) }
  end

  test "should destroy site with no page references" do
    site = Site.create!(
      name: "Test Site",
      slug: "test-site-#{Time.now.to_i}",
      organization: @user.organization
    )
    
    assert_difference("Site.count", -1) do
      delete site_url(site)
    end
    
    assert_redirected_to "/"
    assert_raises(ActiveRecord::RecordNotFound) { site.reload }
  end

  test "should destroy site and associated pages" do
    site = Site.create!(
      name: "Test Site",
      slug: "test-site-#{Time.now.to_i}",
      organization: @user.organization
    )
    
    # Create some regular pages associated with the site
    page1 = Page.create!(
      content: "<html><body>Page 1</body></html>",
      slug: "page-1-#{Time.now.to_i}",
      site: site,
      organization: @user.organization
    )
    
    page2 = Page.create!(
      content: "<html><body>Page 2</body></html>",
      slug: "page-2-#{Time.now.to_i}",
      site: site,
      organization: @user.organization
    )
    
    assert_difference("Site.count", -1) do
      assert_difference("Page.count", -2) do
        delete site_url(site)
      end
    end
    
    assert_redirected_to "/"
    assert_raises(ActiveRecord::RecordNotFound) { site.reload }
    assert_raises(ActiveRecord::RecordNotFound) { page1.reload }
    assert_raises(ActiveRecord::RecordNotFound) { page2.reload }
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

  def should_destroy_site_with_home_page_and_after_submission_page_references
    assert_difference("Site.count", -1) do
      delete site_url(@site)
    end

    assert_redirected_to "/"
  end
end