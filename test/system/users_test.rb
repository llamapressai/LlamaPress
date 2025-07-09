require "application_system_test_case"

class UsersTest < ApplicationSystemTestCase
  setup do
    @user = users(:one)
  end

  test "should register user" do
    visit "/users/sign_up"
    fill_in id: "website-prompt", with: "I want a website for my coffee shop"
    click_on "Generate your website"
    fill_in "Email", with: "test@test.com"
    fill_in "Password", with: "1234567890"
    fill_in "Confirm Password", with: "1234567890"
    click_on "Create my website"
    
    # Should be redirected to the page with default content
    assert_current_path %r{/pages/\d+}
    # Should have page content indicating successful redirect
    assert_text "Hello, world!"
  end

  test "should login user with prompt" do
    @user.password = "1234567890"
    @user.save
    visit "/users/sign_up"  # Go to the registration page which has our prompt flow
    fill_in id: "website-prompt", with: "I want a portfolio website"
    click_on "Generate your website"
    
    # Click the "Already have an account? Sign in" link to switch to sign-in form
    find('a', text: 'Sign in').click
    
    fill_in "Email", with: @user.email
    fill_in "Password", with: "1234567890"
    click_on "Sign in and create website"
    
    # Should be redirected to home page for existing users
    assert_current_path "/home"
    assert_text "Welcome to LlamaPress!"
  end

  test "user should be authenticated after signing in with prompt" do
    @user.password = "1234567890"
    @user.save
    
    visit "/users/sign_up"
    fill_in id: "website-prompt", with: "I want a restaurant website"
    click_on "Generate your website"
    
    # Switch to sign-in form
    find('a', text: 'Sign in').click
    
    fill_in "Email", with: @user.email
    fill_in "Password", with: "1234567890"
    click_on "Sign in and create website"
    
    # Should be redirected to home for existing users
    assert_current_path "/home"
    
    # The user should be authenticated - check by visiting a protected page
    visit "/users/edit"
    # If not authenticated, we should be redirected to sign in page
    # If authenticated, we should see the edit form
    if page.has_text?("Sign in")
      flunk "User was not authenticated - redirected to sign in page"
    else
      # If we're on the edit page, check for edit form elements
      assert page.has_text?("Edit User") || page.has_field?("user[email]") || page.has_field?("Email"), "Should show edit form if authenticated"
    end
  end

  test "should require authentication for protected pages" do
    visit "/users/edit"
    # Should be redirected to sign in page since we're not authenticated
    assert page.has_text?("Sign in") || page.has_text?("Log in"), "Should be redirected to sign in page when not authenticated"
  end

  test "should maintain authentication state after redirect with prompt" do
    @user.password = "1234567890"
    @user.save
    
    visit "/users/sign_up"
    fill_in id: "website-prompt", with: "I want a restaurant website"
    click_on "Generate your website"
    
    # Switch to sign-in form
    find('a', text: 'Sign in').click
    
    fill_in "Email", with: @user.email
    fill_in "Password", with: "1234567890"
    click_on "Sign in and create website"
    
    # Should be redirected to home for existing users
    assert_current_path "/home"
    
    # Check if we can access the current user's information
    visit "/users/#{@user.id}"
    # Should be able to access the user show page if authenticated
    if page.has_text?("Sign in") || page.has_text?("Log in")
      flunk "User was not authenticated - redirected to sign in page after prompt signin"
    else
      # Should see user information or be able to access the user page
      assert page.has_text?(@user.email) || page.has_text?("User") || page.has_text?("Edit"), "Should be able to access user page if authenticated"
    end
  end

  test "user should have full authenticated access after prompt signin" do
    @user.password = "1234567890"
    @user.save
    
    # Sign in with prompt
    visit "/users/sign_up"
    fill_in id: "website-prompt", with: "I want a tech startup website"
    click_on "Generate your website"
    
    find('a', text: 'Sign in').click
    
    fill_in "Email", with: @user.email
    fill_in "Password", with: "1234567890"
    click_on "Sign in and create website"
    
    # Should be redirected to home for existing users
    assert_current_path "/home"
    
    # Test multiple protected routes to ensure full authentication
    protected_routes = [
      "/users/#{@user.id}",
      "/users/#{@user.id}/edit",
      "/sites",
      "/pages"
    ]
    
    protected_routes.each do |route|
      visit route
      # If we get redirected to sign in, the user is not properly authenticated
      if page.has_text?("Sign in") || page.has_text?("Log in") 
        flunk "User was not authenticated when accessing #{route} - redirected to sign in page"
      end
    end
    
    # If we get here, user is properly authenticated for all protected routes
    assert true, "User successfully authenticated for all protected routes"
  end
end