class Site < ApplicationRecord
  belongs_to :organization
  has_many :pages, dependent: :destroy
  validates :name, presence: true
end
