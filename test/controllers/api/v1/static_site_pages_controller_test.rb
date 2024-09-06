require "controllers/api/v1/test"

class Api::V1::StaticSitePagesControllerTest < Api::Test
  def setup
    # See `test/controllers/api/test.rb` for common set up for API tests.
    super

    @static_site = create(:static_site, team: @team)
    @static_site_page = build(:static_site_page, static_site: @static_site)
    @other_static_site_pages = create_list(:static_site_page, 3)

    @another_static_site_page = create(:static_site_page, static_site: @static_site)

    # 🚅 super scaffolding will insert file-related logic above this line.
    @static_site_page.save
    @another_static_site_page.save

    @original_hide_things = ENV["HIDE_THINGS"]
    ENV["HIDE_THINGS"] = "false"
    Rails.application.reload_routes!
  end

  def teardown
    super
    ENV["HIDE_THINGS"] = @original_hide_things
    Rails.application.reload_routes!
  end

  # This assertion is written in such a way that new attributes won't cause the tests to start failing, but removing
  # data we were previously providing to users _will_ break the test suite.
  def assert_proper_object_serialization(static_site_page_data)
    # Fetch the static_site_page in question and prepare to compare it's attributes.
    static_site_page = StaticSitePage.find(static_site_page_data["id"])

    assert_equal_or_nil static_site_page_data['content'], static_site_page.content
    assert_equal_or_nil static_site_page_data['slug'], static_site_page.slug
    assert_equal_or_nil static_site_page_data['prompt'], static_site_page.prompt
    # 🚅 super scaffolding will insert new fields above this line.

    assert_equal static_site_page_data["static_site_id"], static_site_page.static_site_id
  end

  test "index" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/static_sites/#{@static_site.id}/static_site_pages", params: {access_token: access_token}
    assert_response :success

    # Make sure it's returning our resources.
    static_site_page_ids_returned = response.parsed_body.map { |static_site_page| static_site_page["id"] }
    assert_includes(static_site_page_ids_returned, @static_site_page.id)

    # But not returning other people's resources.
    assert_not_includes(static_site_page_ids_returned, @other_static_site_pages[0].id)

    # And that the object structure is correct.
    assert_proper_object_serialization response.parsed_body.first
  end

  test "show" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/static_site_pages/#{@static_site_page.id}", params: {access_token: access_token}
    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # Also ensure we can't do that same action as another user.
    get "/api/v1/static_site_pages/#{@static_site_page.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end

  test "create" do
    # Use the serializer to generate a payload, but strip some attributes out.
    params = {access_token: access_token}
    static_site_page_data = JSON.parse(build(:static_site_page, static_site: nil).api_attributes.to_json)
    static_site_page_data.except!("id", "static_site_id", "created_at", "updated_at")
    params[:static_site_page] = static_site_page_data

    post "/api/v1/static_sites/#{@static_site.id}/static_site_pages", params: params
    assert_response :success

    # # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # Also ensure we can't do that same action as another user.
    post "/api/v1/static_sites/#{@static_site.id}/static_site_pages",
      params: params.merge({access_token: another_access_token})
    assert_response :not_found
  end

  test "update" do
    # Post an attribute update ensure nothing is seriously broken.
    put "/api/v1/static_site_pages/#{@static_site_page.id}", params: {
      access_token: access_token,
      static_site_page: {
        content: 'Alternative String Value',
        slug: 'Alternative String Value',
        prompt: 'Alternative String Value',
        # 🚅 super scaffolding will also insert new fields above this line.
      }
    }

    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # But we have to manually assert the value was properly updated.
    @static_site_page.reload
    assert_equal @static_site_page.content, 'Alternative String Value'
    assert_equal @static_site_page.slug, 'Alternative String Value'
    assert_equal @static_site_page.prompt, 'Alternative String Value'
    # 🚅 super scaffolding will additionally insert new fields above this line.

    # Also ensure we can't do that same action as another user.
    put "/api/v1/static_site_pages/#{@static_site_page.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end

  test "destroy" do
    # Delete and ensure it actually went away.
    assert_difference("StaticSitePage.count", -1) do
      delete "/api/v1/static_site_pages/#{@static_site_page.id}", params: {access_token: access_token}
      assert_response :success
    end

    # Also ensure we can't do that same action as another user.
    delete "/api/v1/static_site_pages/#{@another_static_site_page.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end
end
