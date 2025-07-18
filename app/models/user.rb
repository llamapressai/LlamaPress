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
  before_save :set_public_id, :set_api_token

  belongs_to :default_site, class_name: "Site", optional: true

  # If you want to allow the user to optionally create an org, add:
  before_validation :create_default_organization, on: :create

  def notify_registration
    if Rails.env.production?
      Rails.logger.info("🎉 New LlamaPress User Registration! email: #{self.email}, organization: #{self.organization.name}, name: #{self.first_name} #{self.last_name}, phone: #{self.phone}")

    end
  end

  # Determines if the user needs to still go through the tutorial.
  def needs_tutorial?
    return false #disable the tutorial for now.
    #return self.tutorial_step >= 0 && self.tutorial_step <= 10 #if tutorial step < 0, then user opted out. If tutorial step > 10, then user has completed the tutorial.
  end

  # This is the path that the user will be redirected to based on the tutorial step they're on.
  def tutorial_step_path
    if self.tutorial_step >= 0 && self.tutorial_step < 2
      "/pages/#{self.organization.sites.first.pages.first.id}"
    elsif self.tutorial_step == 3
      "/pages/new"
    elsif self.tutorial_step == 4
      "/pages/#{self.organization.sites.first.pages.second.id}"
    elsif self.tutorial_step == 5
      "/home"
    elsif self.tutorial_step == 6
      "/recommended-3rd-party-apps"
    elsif self.tutorial_step == 7
      "/pages/#{self.organization.sites.first.pages.second.id}/edit"
    else
      "/home"
    end
  end

  def set_public_id
    if self.public_id.nil?
      self.public_id = SecureRandom.uuid
      self.save
    end
  end

  def set_api_token
    if self.api_token.nil?
      self.api_token = SecureRandom.uuid
      self.save
    end
  end

  def should_we_allow_user_to_send_this_message?
    return true
  end

  #Used to check the number of messages the user has sent today.
  # Note: Chat messages are now handled by LlamaBot backend, so this returns 0
  def today_message_count
    0
  end

  private

  def create_default_organization
    self.build_organization if organization.nil?
  end

end