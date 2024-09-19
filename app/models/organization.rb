class Organization < ApplicationRecord
    has_many :users, dependent: :destroy
    has_many :sites, dependent: :destroy
    has_many :pages, dependent: :destroy
end