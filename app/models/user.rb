class User < ApplicationRecord
  require 'twilio'
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable

  belongs_to :organization
  has_many :sites, through: :organization

  accepts_nested_attributes_for :organization
  after_create :notify_registration

  belongs_to :default_site, class_name: "Site", optional: true

  # If you want to allow the user to optionally create an org, add:
  before_validation :create_default_organization, on: :create

  def notify_registration
    Twilio.send_text("9152845787", "New User Registration: email: #{self.email}, organization: #{self.organization.name}, name: #{self.first_name} #{self.last_name}, phone: #{self.phone}")
    Twilio.send_text("3853001203", "New User Registration: email: #{self.email}, organization: #{self.organization.name}, name: #{self.first_name} #{self.last_name}, phone: #{self.phone}")
  end

  private

  def create_default_organization
    self.build_organization if organization.nil?
  end

  def set_public_id
    self.public_id ||= self.id
  end
end