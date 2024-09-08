class StaticWebSite < ApplicationRecord
  belongs_to :organization
  has_many :static_web_site_pages, dependent: :destroy
  validates :name, presence: true
end
