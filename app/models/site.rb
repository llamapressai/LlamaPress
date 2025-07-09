class Site < ApplicationRecord
  # First nullify the references
  before_destroy :nullify_home_page_and_after_submission_page_references
  
  # Then set up the relationships
  belongs_to :organization
  has_many :pages, dependent: :destroy
  has_one :home_page, class_name: "Page", primary_key: "home_page_id", foreign_key: "id"
  has_one :after_submission_page, class_name: "Page", primary_key: "after_submission_page_id", foreign_key: "id"

  has_many :submissions, dependent: :destroy
  has_many_attached :images
  validates :name, presence: true
  before_validation :make_unique_slug, on: :create

  # Helper method to extract image metadata and URL
  def extract_image_data(image)
    {
      image: image,
      content_type: image.blob.content_type,
      id: image.id, # it's often useful to also send the ID
      filename: image.blob.filename.to_s,
      url: image.service.send(:object_for, image.key).public_url
    }
  end

  def wordpress_api_decoded_token
    Base64.decode64(wordpress_api_encoded_token) if wordpress_api_encoded_token.present?
  end

  def make_unique_slug
    original_slug = self.slug
    counter = 1
    while Site.exists?(slug: self.slug)
      self.slug = "#{original_slug}-#{counter}"
      counter += 1
    end
  end
  private

  def nullify_home_page_and_after_submission_page_references
    # Use update_columns to bypass callbacks and validations
    update_columns(
      home_page_id: nil,
      after_submission_page_id: nil
    )
  end
end