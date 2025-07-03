class Organization < ApplicationRecord
    include PagesHelper
    has_many :users, dependent: :destroy
    has_many :sites, dependent: :destroy
    has_many :pages, dependent: :destroy
  
    after_create :create_default_site_and_page

    def create_default_site_and_page
        random_uid = SecureRandom.uuid.slice(0, 5)

        @site = Site.create(
            slug: "tutorial-site-#{random_uid}",
            organization: self,
            name: "Your Tutorial Site"
        )

        @page = Page.create(
            slug: "/tutorial-page-#{random_uid}",
            content: PagesHelper.starting_html_content,
            site: @site,
            organization: self
        )
    end
end