require "test_helper"

class PagesControllerAgentAuthTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  
  setup do
    @user = users(:one)
    @page = pages(:one)
    @valid_token = Rails.application.message_verifier(:llamabot_ws).generate({session_id: 'test'})
    @invalid_token = 'invalid-token'
    @expired_token = Rails.application.message_verifier(:llamabot_ws).generate(
      {session_id: 'test'}, 
      expires_in: -1.minute
    )
  end

  # Test agent authentication with valid tokens
  test "should allow agent update with valid token" do
    patch page_url(@page), 
      params: { page: { content: "<h1>Updated by agent</h1>" } },
      headers: { 'Authorization' => "LlamaBot #{@valid_token}" }
    
    assert_response :redirect  # Update redirects to page on success
    @page.reload
    assert_includes @page.content, "Updated by agent"
  end

  test "should reject agent update with invalid token" do
    patch page_url(@page), 
      params: { page: { content: "<h1>Should not work</h1>" } },
      headers: { 'Authorization' => "LlamaBot #{@invalid_token}" }
    
    assert_response :redirect  # Redirects to sign in when auth fails
    assert_redirected_to new_user_session_path
  end

  test "should reject agent update with expired token" do
    patch page_url(@page), 
      params: { page: { content: "<h1>Should not work</h1>" } },
      headers: { 'Authorization' => "LlamaBot #{@expired_token}" }
    
    assert_response :redirect  # Redirects to sign in when auth fails
    assert_redirected_to new_user_session_path
  end

  test "should reject agent update with malformed authorization header" do
    patch page_url(@page), 
      params: { page: { content: "<h1>Should not work</h1>" } },
      headers: { 'Authorization' => "Bearer #{@valid_token}" }
    
    assert_response :redirect  # Redirects to sign in when auth fails
    assert_redirected_to new_user_session_path
  end

  test "should reject agent update with missing authorization header" do
    patch page_url(@page), 
      params: { page: { content: "<h1>Should not work</h1>" } }
    
    assert_response :redirect  # Redirects to sign in when auth fails
    assert_redirected_to new_user_session_path
  end

  # Test whitelist enforcement
  test "should reject agent access to non-whitelisted action" do
    delete page_url(@page), 
      headers: { 'Authorization' => "LlamaBot #{@valid_token}" }
    
    assert_response :forbidden
    response_body = JSON.parse(response.body)
    assert_includes response_body["error"], "Action 'destroy' isn't white-listed for LlamaBot"
    assert_includes response_body["error"], "llama_bot_allow :method"
  end

  test "should reject agent access to edit action" do
    get edit_page_url(@page), 
      headers: { 'Authorization' => "LlamaBot #{@valid_token}" }
    
    assert_response :forbidden
    response_body = JSON.parse(response.body)
    assert_includes response_body["error"], "Action 'edit' isn't white-listed for LlamaBot"
  end

  test "should reject agent access to index action" do
    get pages_url, 
      headers: { 'Authorization' => "LlamaBot #{@valid_token}" }
    
    assert_response :forbidden
    response_body = JSON.parse(response.body)
    assert_includes response_body["error"], "Action 'index' isn't white-listed for LlamaBot"
  end

  # Test that regular user authentication still works
  test "should allow signed in user to update page" do
    sign_in @user
    patch page_url(@page), params: { page: { content: "<h1>Updated by user</h1>" } }
    
    assert_response :redirect
    @page.reload
    assert_includes @page.content, "Updated by user"
  end

  test "should allow signed in user to access all actions" do
    sign_in @user
    
    # Test various actions that should work for users
    get pages_url
    assert_response :success
    
    get edit_page_url(@page)
    assert_response :success
    
    get page_url(@page)
    assert_response :success
  end

  test "should allow signed in user to delete page" do
    sign_in @user
    
    assert_difference("Page.count", -1) do
      delete page_url(@page)
    end
    
    assert_response :redirect
  end

  # Test public actions still work without authentication
  test "should allow public access to show action" do
    get page_url(@page)
    assert_response :success
  end

  test "should allow public access to resolve_slug action" do
    site = sites(:one)
    ENV["OVERRIDE_DOMAIN"] = site.slug
    get "/#{@page.slug}"
    assert_response :success
  end

  test "should allow public access to sitemap_xml action" do
    # Set up a site for the sitemap test
    site = sites(:one)
    ENV["OVERRIDE_DOMAIN"] = site.slug
    
    get "/sitemap.xml"
    assert_response :success
  end

  test "should allow public access to robots_txt action" do
    get "/robots.txt"
    assert_response :success
  end

  # Test mixed authentication scenarios
  test "should prioritize user authentication over agent authentication" do
    sign_in @user
    
    # Even with a valid agent token, user auth should take precedence
    # and allow access to non-whitelisted actions
    delete page_url(@page), 
      headers: { 'Authorization' => "LlamaBot #{@valid_token}" }
    
    assert_response :redirect  # User auth allows delete
  end

  test "should fallback to agent auth when user not signed in" do
    # Not signed in, but valid agent token for whitelisted action
    patch page_url(@page), 
      params: { page: { content: "<h1>Agent update</h1>" } },
      headers: { 'Authorization' => "LlamaBot #{@valid_token}" }
    
    assert_response :redirect  # Update redirects on success
    @page.reload
    assert_includes @page.content, "Agent update"
  end

  # Test that the llama_bot_allow directive is properly configured
  test "should have update action in llama_bot_permitted_actions" do
    assert_includes PagesController.llama_bot_permitted_actions, 'update',
      "update action should be in llama_bot_permitted_actions"
  end

  test "should not have non-whitelisted actions in llama_bot_permitted_actions" do
    assert_not_includes PagesController.llama_bot_permitted_actions, 'destroy',
      "destroy action should not be in llama_bot_permitted_actions"
    assert_not_includes PagesController.llama_bot_permitted_actions, 'edit',
      "edit action should not be in llama_bot_permitted_actions"
    assert_not_includes PagesController.llama_bot_permitted_actions, 'index',
      "index action should not be in llama_bot_permitted_actions"
  end

  # Test edge cases with token verification
  test "should handle empty authorization header gracefully" do
    patch page_url(@page), 
      params: { page: { content: "<h1>Should not work</h1>" } },
      headers: { 'Authorization' => "" }
    
    assert_response :redirect  # Redirects to sign in when auth fails
    assert_redirected_to new_user_session_path
  end

  test "should handle malformed token gracefully" do
    patch page_url(@page), 
      params: { page: { content: "<h1>Should not work</h1>" } },
      headers: { 'Authorization' => "LlamaBot" }
    
    assert_response :redirect  # Redirects to sign in when auth fails
    assert_redirected_to new_user_session_path
  end

  test "should handle token with wrong signature gracefully" do
    # Create a token with wrong signature by tampering with it
    tampered_token = @valid_token + "tampered"
    
    patch page_url(@page), 
      params: { page: { content: "<h1>Should not work</h1>" } },
      headers: { 'Authorization' => "LlamaBot #{tampered_token}" }
    
    assert_response :redirect  # Redirects to sign in when auth fails
    assert_redirected_to new_user_session_path
  end

  # Test that the controller includes the necessary modules
  test "should include LlamaBotRails::ControllerExtensions" do
    assert_includes PagesController.ancestors, LlamaBotRails::ControllerExtensions,
      "PagesController should include LlamaBotRails::ControllerExtensions"
  end

  test "should include LlamaBotRails::AgentAuth" do
    assert_includes PagesController.ancestors, LlamaBotRails::AgentAuth,
      "PagesController should include LlamaBotRails::AgentAuth"
  end

  # Test that the global allowed_routes registry is updated
  test "should register allowed routes in global registry" do
    # Trigger the registration by accessing the class
    PagesController.llama_bot_permitted_actions
    
    # Check that the route is registered
    assert_includes LlamaBotRails.allowed_routes.to_a, 'pages#update',
      "pages#update should be in global allowed_routes registry"
  end

  test "should not register non-whitelisted routes in global registry" do
    # Trigger the registration by accessing the class
    PagesController.llama_bot_permitted_actions
    
    # These should not be registered since they're not whitelisted
    refute_includes LlamaBotRails.allowed_routes.to_a, 'pages#destroy',
      "pages#destroy should not be in global allowed_routes registry"
    refute_includes LlamaBotRails.allowed_routes.to_a, 'pages#edit',
      "pages#edit should not be in global allowed_routes registry"
  end

  # Test that authenticate_user_or_agent! method exists (from LlamaBotRails::AgentAuth)
  test "should have authenticate_user_or_agent method from LlamaBotRails::AgentAuth" do
    controller = PagesController.new
    assert controller.respond_to?(:authenticate_user_or_agent!, true), 
      "authenticate_user_or_agent! method should exist from LlamaBotRails::AgentAuth module"
  end

  # Test that agent authentication works properly with JSON requests
  test "should allow agent JSON update with valid token" do
    patch page_url(@page), 
      params: { page: { content: "<h1>Updated by agent JSON</h1>" } }.to_json,
      headers: { 
        'Authorization' => "LlamaBot #{@valid_token}",
        'Content-Type' => 'application/json',
        'Accept' => 'application/json'
      }
    
    assert_response :ok
    @page.reload
    assert_includes @page.content, "Updated by agent JSON"
  end

  test "should reject agent JSON request to non-whitelisted action" do
    delete page_url(@page), 
      headers: { 
        'Authorization' => "LlamaBot #{@valid_token}",
        'Content-Type' => 'application/json',
        'Accept' => 'application/json'
      }
    
    assert_response :forbidden
    response_body = JSON.parse(response.body)
    assert_includes response_body["error"], "Action 'destroy' isn't white-listed for LlamaBot"
  end

  teardown do
    ENV.delete("OVERRIDE_DOMAIN")
  end
end 