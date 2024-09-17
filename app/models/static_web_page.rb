class StaticWebPage < ApplicationRecord
  extend FriendlyId
  belongs_to :static_web_site, optional: true
  belongs_to :organization
  has_many :static_web_page_histories, dependent: :destroy

  before_create :ensure_static_web_site
  after_initialize :set_default_html_content, if: :new_record?

  friendly_id :slug, use: :slugged

  # Ensure the static web page has a static web site. If not, create one so the user doesn't have to.
  def ensure_static_web_site
    return if static_web_site.present?

    self.static_web_site = organization.static_web_sites.first || create_new_static_web_site
  end

  def restore(static_web_page_history)
    self.save_history
    self.content = static_web_page_history.content
    self.save
  end

  def save_history()
    static_web_page_history = StaticWebPageHistory.new
    static_web_page_history.content = self.content
    static_web_page_history.user_message = "Restore to previous version"
    static_web_page_history.static_web_page_id = self.id
    static_web_page_history.save
  end

  # Set the default html content for the static web page
  def set_default_html_content
    self.content = StaticWebPagesHelper.starting_html_content()
  end

  private

  # Create a new static web site for the organization
  def create_new_static_web_site
    name = generate_unique_name
    StaticWebSite.create!(name: name, organization: organization)
  end

  # Generate a unique name for the static web site
  def generate_unique_name
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
