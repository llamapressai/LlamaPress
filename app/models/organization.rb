class Organization < ApplicationRecord
    has_many :users
    has_many :static_web_sites
end
