class Organization < ApplicationRecord
    include PagesHelper

    has_many :users, dependent: :destroy
    has_many :sites, dependent: :destroy
    has_many :pages, dependent: :destroy

    after_create :create_default_site_and_page

    def create_default_site_and_page
        @site = Site.create(
            slug: self.users&.first&.email,
            organization: self,
            name: "#{self.users&.first&.email}'s Page"
        )

        @page = Page.create(
            slug: '/',
            content: PagesHelper.starting_html_content,
            site: @site,
            organization: self
        )
    end
end