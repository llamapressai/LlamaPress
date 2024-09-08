require "test_helper"

class StaticWebPagesControllerTest < ActionDispatch::IntegrationTest
  setup do
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
    patch static_web_page_url(@static_web_page), params: { static_web_page: { content: @static_web_page.content, prompt: @static_web_page.prompt, slug: @static_web_page.slug, static_web_site_id: @static_web_page.static_web_site_id } }
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
end