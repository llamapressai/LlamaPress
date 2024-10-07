class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  belongs_to :organization
  accepts_nested_attributes_for :organization

  belongs_to :default_site, class_name: "Site", optional: true

  # If you want to allow the user to optionally create an org, add:
  before_validation :create_default_organization, on: :create

  private

  def create_default_organization
    self.build_organization if organization.nil?
  end
end
