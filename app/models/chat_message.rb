class ChatMessage < ApplicationRecord
  before_validation :assign_uuid, on: :create
  
  enum sender: { human_message: 0, ai_message: 1 }
  
  belongs_to :user
  belongs_to :chat_conversation
  has_many :message_reactions, dependent: :destroy
  
  validates :content, presence: true
  validates :sender, presence: true
  validates :uuid, presence: true, uniqueness: true

  def thumbs_up_count
    message_reactions.where(reaction_type: 'up').count
  end
  
  def thumbs_down_count
    message_reactions.where(reaction_type: 'down').count
  end
  
  private

  def assign_uuid
    self.uuid = SecureRandom.uuid
  end
end