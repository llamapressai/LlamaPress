# params
# #<ActionController::Parameters {"authenticity_token"=>"wKJImA7CdpUKUm-NFnIe1O3THbINoapGWVsmrDoBWzKoaMKg3QLzMeQ_ImjXr-fN59vfV1eldK3TmkdA_77OlQ", "prompt"=>"Build me a page for solar company in san francisco", "credentials"=>"eyJ1c2VybmFtZSI6InVzZXIiLCJwYXNzd29yZCI6Ijc2NklJeENZWXU0UjF0YkNXT2JkNWQ0diIsImRvbWFpbiI6Imh0dHA6XC9cL2xvY2FsaG9zdDo4MDgwIiwidGVtcGxhdGVfaWQiOiJsbGFtYV90ZW1wbGF0ZS5waHAifQ==", "email"=>"kodysolarsf2@gmail.com", "password"=>"password", "controller"=>"public_leads", "action"=>"create_from_prompt_in_wordpress_registration"} permitted: false>
# (byebug) 

require "test_helper"

class PublicLeadsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  setup do
    @user = users(:one)
    sign_in @user
    @page = pages(:one)
  end

  test "should create" do
    
    assert_difference("Site.count") do
      post "/public_leads/create_from_prompt_in_wordpress_registration", params: {
        prompt: "Build me a page for solar company in san francisco",
        credentials: "eyJ1c2VybmFtZSI6InVzZXIiLCJwYXNzd29yZCI6Ijc2NklJeENZWXU0UjF0YkNXT2JkNWQ0diIsImRvbWFpbiI6Imh0dHA6XC9cL2xvY2FsaG9zdDo4MDgwIiwidGVtcGxhdGVfaWQiOiJsbGFtYV90ZW1wbGF0ZS5waHAifQ==",
        email: "kodysolarsf2@gmail.com",
        password: "password"
      }
    end

    site = Site.last
    assert_equal "eyJ1c2VybmFtZSI6InVzZXIiLCJwYXNzd29yZCI6Ijc2NklJeENZWXU0UjF0YkNXT2JkNWQ0diIsImRvbWFpbiI6Imh0dHA6XC9cL2xvY2FsaG9zdDo4MDgwIiwidGVtcGxhdGVfaWQiOiJsbGFtYV90ZW1wbGF0ZS5waHAifQ==", site.wordpress_api_encoded_token
    assert_response :redirect
  end

  test "should create brand clone happy path" do
    sign_out @user
    post "/public_leads/register_and_brand_clone", params: {
      website_url: "https://www.kodysolarsf.com",
      business_name: "Kody Solar SF",
      full_name: "Kody Solar SF",
      email: "kodysolarsf2@gmail.com",
      password: "password",
      password_confirmation: "password",
      phone: "1234567890"
    }

    assert_response :redirect
    site = Site.last
    assert_equal "Kody Solar SF", site.name
    assert_equal "https://www.kodysolarsf.com", site.slug
    
    user = User.last
    assert_equal "kodysolarsf2@gmail.com", user.email
    assert_equal "initial-clone-Kody Solar SF", site.pages.first.slug
  end


  test "should create brand clone unhappy path" do #Try to break it
    sign_out @user
    post "/public_leads/register_and_brand_clone", params: {
      website_url: "https://www.kodysolarsf.com",
      business_name: "Kody Solar SF",
    }
  end

end