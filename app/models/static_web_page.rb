class StaticWebPage < ApplicationRecord
  belongs_to :static_web_site, optional: true
  belongs_to :organization

  before_create :ensure_static_web_site

  private

  def ensure_static_web_site
    return if static_web_site.present?

    self.static_web_site = organization.static_web_sites.first || create_new_static_web_site
  end

  def create_new_static_web_site
    title = generate_unique_title
    StaticWebSite.create!(title: title, organization: organization)
  end

  def generate_unique_title
    base_title = business_name.presence || 'Default Site'
    title = base_title
    index = 1

    while StaticWebSite.exists?(title: title)
      title = "#{base_title} #{index}"
      index += 1
    end

    title
  end
end
