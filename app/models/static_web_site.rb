class StaticWebSite < ApplicationRecord
  belongs_to :organization
  has_many :static_web_pages, dependent: :destroy
  validates :name, presence: true
end
