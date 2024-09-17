require "test_helper"

class StaticWebPagesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  setup do
    @user = users(:one)
    sign_in @user
    @static_web_page = static_web_pages(:one)
  end

  test "should get index" do
    get static_web_pages_url
    assert_response :success
  end

  test "should get new" do
    get new_static_web_page_url
    assert_response :success
  end

  test "should create static_web_page" do
    assert_difference("StaticWebPage.count") do
      post static_web_pages_url, params: { static_web_page: { content: @static_web_page.content, prompt: @static_web_page.prompt, slug: @static_web_page.slug, static_web_site_id: @static_web_page.static_web_site_id } }
    end

    assert_redirected_to static_web_page_url(StaticWebPage.last)
  end

  test "should show static_web_page" do
    get static_web_page_url(@static_web_page)
    assert_response :success
  end

  test "should get edit" do
    get edit_static_web_page_url(@static_web_page)
    assert_response :success
  end

  test "should update static_web_page" do
    patch static_web_page_url(@static_web_page), params: { static_web_page: { content: @static_web_page.content, prompt: @static_web_page.prompt, slug: "@static_web_page.slug#{Time.now.to_i}", static_web_site_id: @static_web_page.static_web_site_id, organization_id: @static_web_page.organization_id } }
    #TODO: Fix and discuss - organization_id issues with static_web_page.
    assert_redirected_to static_web_page_url(@static_web_page)
  end

  test "should destroy static_web_page" do
    assert_difference("StaticWebPage.count", -1) do
      delete static_web_page_url(@static_web_page)
    end

    assert_redirected_to static_web_pages_url
  end

  test "should create static web page without needing user to create static web site" do
    organization = organizations(:one)
    assert_difference("StaticWebPage.count") do
      post static_web_pages_url, params: { static_web_page: { 
        content: @static_web_page.content, 
        prompt: @static_web_page.prompt, 
        slug: "unique-slug-#{Time.now.to_i}", 
        static_web_site_id: @static_web_page.static_web_site_id 
      } }
    end
    
    assert_response :redirect
    assert_redirected_to static_web_page_url(StaticWebPage.last)
  end

  test "should find static_web_page by friendly id" do
    friendly_id = @static_web_page.slug
    get static_web_page_url(friendly_id)
    assert_response :success
    assert_equal @static_web_page, assigns(:static_web_page)
  end

  test "should find static_web_page by id when friendly id fails" do
    original_slug = @static_web_page.slug
    @static_web_page.update(slug: nil)  # Force friendly_id to fail
    
    get static_web_page_url(@static_web_page.id)
    assert_response :success
    assert_equal @static_web_page, assigns(:static_web_page)

    @static_web_page.update(slug: original_slug)  # Restore the original slug
  end

  test "should resolve slug" do
    @site1 = static_web_sites(:one)
    @site2 = static_web_sites(:two)
    @page1 = static_web_pages(:one)
    @page2 = static_web_pages(:two)

    # Ensure unique slugs for this test

    # Test resolving slug for the current site
    host! @site1.slug
    get "/#{@page1.slug}"
    assert_response :success
    assert_equal @page1, assigns(:static_web_page)

    # Test handling pages across different sites
    host! @site2.slug
    get "/#{@page2.slug}"
    assert_response :success
    assert_equal @page2, assigns(:static_web_page)

    # Test redirecting when no matching page is found
    get '/non-existent-page'
    assert_response :not_found
  end
end