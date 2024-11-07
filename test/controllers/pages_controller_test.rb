require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  setup do
    @user = users(:one)
    sign_in @user
    @page = pages(:one)
  end

  test "should get index" do
    get pages_url
    assert_response :success
  end

  test "should get new" do
    get new_page_url
    assert_response :success
  end

  test "should create page" do
    assert_difference("Page.count") do
      post pages_url, params: { page: { content: @page.content, slug: @page.slug, site_id: @page.site_id } }
    end

    assert_redirected_to page_url(Page.last.id)
  end

  test "should show page" do
    get page_url(@page)
    assert_response :success
  end

  test "should get edit" do
    get edit_page_url(@page)
    assert_response :success
  end

  test "should update page" do
    patch page_url(@page), params: { page: { content: @page.content, slug: "#{@page.slug}-#{Time.now.to_i}", site_id: @page.site_id, organization_id: @page.organization_id } }
    @page.reload #Make sure we get the most up to date slug by reloading this page. Friendly id doesn't update immediately
    assert_redirected_to page_url(@page.id)
  end

  test "should destroy page" do
    assert_difference("Page.count", -1) do
      delete page_url(@page)
    end

    assert_redirected_to pages_url
  end

  test "should create web page without needing user to create web site" do
    organization = organizations(:one)
    assert_difference("Page.count") do
      post pages_url, params: { page: { 
        content: @page.content, 
        slug: "unique-slug-#{Time.now.to_i}", 
        site_id: @page.site_id 
      } }
    end
    
    assert_response :redirect
    assert_redirected_to page_url(Page.last.id)
  end

  test "should find page by friendly id" do
    friendly_id = @page.slug
    get page_url(friendly_id)
    assert_response :success
    assert_equal @page, assigns(:page)
  end

  test "should find page by id when friendly id fails" do
    original_slug = @page.slug
    @page.update(slug: nil)  # Force friendly_id to fail
    
    get page_url(@page.id)
    assert_response :success
    assert_equal @page, assigns(:page)

    @page.update(slug: original_slug)  # Restore the original slug
  end

  test "should resolve slug" do
    @site1 = sites(:one)
    @site2 = sites(:two)
    @page1 = pages(:one)
    @page2 = pages(:two)

    # Ensure unique slugs for this test

    # Test resolving slug for the current site
    ENV["OVERRIDE_DOMAIN"] = @site1.slug #This is how we do it in testing/development.
    get "/#{@page1.slug}"
    assert_response :success
    assert_equal @page1, assigns(:page)

    # Test handling pages across different sites
    ENV["OVERRIDE_DOMAIN"] = @site2.slug #This is how we do it in testing/development.
    get "/#{@page2.slug}"
    assert_response :success
    assert_equal @page2, assigns(:page)

    # Test redirecting when no matching page is found
    get '/non-existent-page'
    assert_response :not_found
  end

  test "should redirect signed in user to llama bot home" do
    sign_in @user
    get root_url
    assert_redirected_to llama_bot_home_path
  end

  test "should show home page for non-signed in user on custom domain" do
    sign_out @user
    @site = sites(:one)
    @page = pages(:one)
    @site.update(home_page_id: @page_id)
    
    ENV["OVERRIDE_DOMAIN"] = @site.slug #This is how we do it in testing/development.
    get root_url
    
    assert_response :success
    assert_equal @page, assigns(:page)
  end

  test "should fallback to first page when no home page is set" do
    sign_out @user
    @site = sites(:one)
    @page = pages(:one)
    @site.update(home_page: nil)
    
    ENV["OVERRIDE_DOMAIN"] = @site.slug #This is how we do it in development.
    
    #Error: it's not finding the @site domain in application_controller.rb.
    get root_url
    
    assert_response :success
    assert_equal @site.pages.first, assigns(:page)
  end

  test "should redirect to llama bot home when site has no pages" do
    sign_out @user
    @site = sites(:one)
    @site.pages.destroy_all
    
    ENV["OVERRIDE_DOMAIN"] = @site.slug #This is how we do it in development.
    get root_url
    
    assert_redirected_to llama_bot_home_path
  end

  test "should redirect signed in user to specific page URL" do
    sign_in @user
    @site = sites(:one)
    @page = pages(:one)
    @site.update(home_page_id: @page.id)
    
    ENV["OVERRIDE_DOMAIN"] = @site.slug #This is how we do it in development.
    get root_url
    
    assert_redirected_to llama_bot_home_path
  end

  test "should render page with analytics in production" do
    sign_out @user
    @site = sites(:one)
    @page = pages(:one)
    
    @site.update(home_page_id: @page.id)
    
    Rails.env.stubs(:production?).returns(true)

    ENV["OVERRIDE_DOMAIN"] = @site.slug #This is how we do it in development.

    get pages_url # will this set controller?

    @page.stubs(:render_content).returns("<div>content</div>")
    @controller.stubs(:inject_analytics_partial).returns("<script>analytics</script>")
    
    get "/#{@page.slug}"
    
    assert_response :success
    assert_includes @response.body, "Put your analytics code here"
    # assert_includes @response.body, "llamabot css"
    assert_includes @response.body, @page.content
  end
end