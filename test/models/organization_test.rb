require "test_helper"

class OrganizationTest < ActiveSupport::TestCase
  test "create_default_site_and_page" do
    organization = Organization.create
    assert organization.sites.count == 1
    assert organization.pages.count == 1
  end
end
