class Site < ApplicationRecord
  belongs_to :organization
  has_many :pages, dependent: :destroy
  has_many :submissions, dependent: :destroy
  
  validates :name, presence: true
end
