class ChatMessage < ApplicationRecord
  before_validation :assign_uuid, on: :create
  
  enum sender: { human_message: 0, ai_message: 1 }
  
  belongs_to :user
  belongs_to :chat_conversation
  
  validates :content, presence: true
  validates :sender, presence: true
  validates :uuid, presence: true, uniqueness: true

  private

  def assign_uuid
    self.uuid = SecureRandom.uuid
  end
end