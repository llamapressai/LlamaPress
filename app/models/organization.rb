class Organization < ApplicationRecord
    has_many :users, dependent: :destroy
    has_many :static_web_sites, dependent: :destroy
    has_many :static_web_pages, dependent: :destroy
end