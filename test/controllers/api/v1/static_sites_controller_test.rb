require "controllers/api/v1/test"

class Api::V1::StaticSitesControllerTest < Api::Test
  def setup
    # See `test/controllers/api/test.rb` for common set up for API tests.
    super

    @static_site = build(:static_site, team: @team)
    @other_static_sites = create_list(:static_site, 3)

    @another_static_site = create(:static_site, team: @team)

    # 🚅 super scaffolding will insert file-related logic above this line.
    @static_site.save
    @another_static_site.save

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
  def assert_proper_object_serialization(static_site_data)
    # Fetch the static_site in question and prepare to compare it's attributes.
    static_site = StaticSite.find(static_site_data["id"])

    assert_equal_or_nil static_site_data['name'], static_site.name
    assert_equal_or_nil static_site_data['slug'], static_site.slug
    # 🚅 super scaffolding will insert new fields above this line.

    assert_equal static_site_data["team_id"], static_site.team_id
  end

  test "index" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/teams/#{@team.id}/static_sites", params: {access_token: access_token}
    assert_response :success

    # Make sure it's returning our resources.
    static_site_ids_returned = response.parsed_body.map { |static_site| static_site["id"] }
    assert_includes(static_site_ids_returned, @static_site.id)

    # But not returning other people's resources.
    assert_not_includes(static_site_ids_returned, @other_static_sites[0].id)

    # And that the object structure is correct.
    assert_proper_object_serialization response.parsed_body.first
  end

  test "show" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/static_sites/#{@static_site.id}", params: {access_token: access_token}
    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # Also ensure we can't do that same action as another user.
    get "/api/v1/static_sites/#{@static_site.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end

  test "create" do
    # Use the serializer to generate a payload, but strip some attributes out.
    params = {access_token: access_token}
    static_site_data = JSON.parse(build(:static_site, team: nil).api_attributes.to_json)
    static_site_data.except!("id", "team_id", "created_at", "updated_at")
    params[:static_site] = static_site_data

    post "/api/v1/teams/#{@team.id}/static_sites", params: params
    assert_response :success

    # # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # Also ensure we can't do that same action as another user.
    post "/api/v1/teams/#{@team.id}/static_sites",
      params: params.merge({access_token: another_access_token})
    assert_response :not_found
  end

  test "update" do
    # Post an attribute update ensure nothing is seriously broken.
    put "/api/v1/static_sites/#{@static_site.id}", params: {
      access_token: access_token,
      static_site: {
        name: 'Alternative String Value',
        slug: 'Alternative String Value',
        # 🚅 super scaffolding will also insert new fields above this line.
      }
    }

    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # But we have to manually assert the value was properly updated.
    @static_site.reload
    assert_equal @static_site.name, 'Alternative String Value'
    assert_equal @static_site.slug, 'Alternative String Value'
    # 🚅 super scaffolding will additionally insert new fields above this line.

    # Also ensure we can't do that same action as another user.
    put "/api/v1/static_sites/#{@static_site.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end

  test "destroy" do
    # Delete and ensure it actually went away.
    assert_difference("StaticSite.count", -1) do
      delete "/api/v1/static_sites/#{@static_site.id}", params: {access_token: access_token}
      assert_response :success
    end

    # Also ensure we can't do that same action as another user.
    delete "/api/v1/static_sites/#{@another_static_site.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end
end
