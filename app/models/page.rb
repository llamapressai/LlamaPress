class Page < ApplicationRecord
  extend FriendlyId
  belongs_to :site, optional: true
  belongs_to :organization
  has_many :page_histories, dependent: :destroy

  before_create :ensure_site
  after_initialize :set_default_html_content, if: :new_record?

  friendly_id :slug, use: :slugged

  # Ensure the web page has a web site. If not, create one so the user doesn't have to.
  def ensure_site
    return if site.present?

    self.site = organization.sites.first || create_new_site
  end

  def restore(page_history)
    self.save_history
    self.content = page_history.content
    self.save
  end

  def save_history()
    page_history = PageHistory.new
    page_history.content = self.content
    page_history.user_message = "Restore to previous version"
    page_history.page_id = self.id
    page_history.save
  end

  # Set the default html content for the web page
  def set_default_html_content
    self.content = PagesHelper.starting_html_content()
  end

  private

  # Create a new web site for the organization
  def create_new_site
    name = generate_unique_name
    Site.create!(name: name, organization: organization)
  end

  # Generate a unique name for the web site
  def generate_unique_name
    base_name = organization.name.presence || self.slug || 'LlamaPress Site'
    name = base_name
    index = 1

    while Site.exists?(name: name)
      name = "#{base_name} #{index}"
      index += 1
    end

    name
  end
end
