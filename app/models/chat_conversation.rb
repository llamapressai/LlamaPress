class ChatConversation < ApplicationRecord
  before_validation :assign_uuid, on: :create

  belongs_to :user
  belongs_to :site, optional: true
  belongs_to :page, optional: true
  has_many :chat_messages, dependent: :destroy
  
  validates :uuid, presence: true, uniqueness: true

  private

  def assign_uuid
    self.uuid = SecureRandom.uuid
  end
end