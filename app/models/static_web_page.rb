class StaticWebPage < ApplicationRecord
  belongs_to :static_web_site, optional: true
  belongs_to :organization

  # Ensure the static web page has a static web site. If not, create one so the user doesn't have to.
  def ensure_static_web_site(organization)
    return if static_web_site.present?

    self.static_web_site = organization.static_web_sites.first || create_new_static_web_site(organization)
  end

  private

  # Create a new static web site for the organization
  def create_new_static_web_site(organization)
    name = generate_unique_name(organization)
    StaticWebSite.create!(name: name, organization: organization)
  end

  # Generate a unique name for the static web site
  def generate_unique_name(organization)
    base_name = organization.name.presence || self.slug || 'LlamaPress Site'
    name = base_name
    index = 1

    while StaticWebSite.exists?(name: name)
      name = "#{base_name} #{index}"
      index += 1
    end

    name
  end
end
