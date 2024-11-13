class ChatMessage < ApplicationRecord
  before_create :assign_uuid
  
  enum sender: { human_message: 0, ai_message: 1 }
  
  belongs_to :user
  belongs_to :chat_conversation
  belongs_to :site
  
  validates :content, presence: true
  validates :sender, presence: true
  validates :uuid, presence: true, uniqueness: true

  private

  def assign_uuid
    self.uuid = SecureRandom.uuid
  end
end