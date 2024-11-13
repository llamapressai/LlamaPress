class ChatConversation < ApplicationRecord
  before_create :assign_uuid
  
  belongs_to :user
  belongs_to :site
  has_many :chat_messages, dependent: :destroy
  
  validates :uuid, presence: true, uniqueness: true

  private

  def assign_uuid
    self.uuid = SecureRandom.uuid
  end
end