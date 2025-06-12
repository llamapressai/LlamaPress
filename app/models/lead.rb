class Lead < ApplicationRecord
  has_one_attached :image
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :image, presence: true
end
