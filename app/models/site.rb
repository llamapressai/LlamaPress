class Site < ApplicationRecord
  belongs_to :organization
  has_many :pages, dependent: :destroy
  has_one :home_page, class_name: "Page", primary_key: "home_page_id", foreign_key: "id"

  has_many :submissions, dependent: :destroy
  has_many :snippets, dependent: :destroy
  has_many_attached :images
  validates :name, presence: true

  # Helper method to extract image metadata and URL
  def extract_image_data(image)
    {
      image: image,
      content_type: image.blob.content_type,
      id: image.id, # it's often useful to also send the ID
      filename: image.blob.filename.to_s,
      content_type: image.blob.content_type,
      url: image.service.send(:object_for, image.key).public_url
    }
  end
end
