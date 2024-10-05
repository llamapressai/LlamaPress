require 'test_helper'

class ApplicationControllerTest < ActionDispatch::IntegrationTest
  class TestController < ApplicationController
    def index
      @site = current_site
      render plain: 'OK'
    end
  end

  setup do
    Rails.application.routes.draw do
      get 'test' => 'test#index'
    end
    ENV.delete("OVERRIDE_DOMAIN") #Don't use override domain that's in developer's local_env.yml
  end

  teardown do
    Rails.application.reload_routes!
    ENV.delete("OVERRIDE_DOMAIN")#Don't use override domain that's in developer's local_env.yml
  end

  test "current_site when OVERRIDE_DOMAIN is set" do
    controller = TestController.new
    override_site = Site.create!(slug: 'override.com', name: 'override.com', organization: organizations(:one))
    ENV["OVERRIDE_DOMAIN"] = "override.com"

    get '/test'
    assert_equal override_site, controller.current_site
  ensure
    ENV.delete("OVERRIDE_DOMAIN")
  end

  test "current_site with www subdomain" do
    controller = TestController.new
    site = Site.create!(slug: 'example.com', name: 'example.com', organization: organizations(:one))
    host! 'www.example.com'

    # Mock the request environment
    request = ActionDispatch::TestRequest.create
    request.env['HTTP_HOST'] = 'www.example.com'
    controller.request = request

    get '/test'
    assert_equal site, controller.current_site
  end

  test "current_site without www subdomain" do
    controller = ApplicationController.new
    site = Site.create!(slug: 'example.com', name: 'example.com', organization: organizations(:one))
    
    # Mock the request environment
    request = ActionDispatch::TestRequest.create
    request.env['HTTP_HOST'] = 'example.com'
    controller.request = request

    assert_equal site, controller.current_site
  end
end