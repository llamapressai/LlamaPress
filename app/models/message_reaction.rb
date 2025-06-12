class MessageReaction < ApplicationRecord
  belongs_to :chat_message, optional: true
  belongs_to :page_history
  belongs_to :user, optional: true
  
  validates :reaction_type, inclusion: { in: ['up', 'down'] }
  validates :chat_message_id, uniqueness: { scope: :user_id }, if: -> { user_id.present? }
end