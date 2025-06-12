class PageHistory < ApplicationRecord
  belongs_to :page
  has_one :message_reaction, dependent: :nullify

  # This is the user's message that they sent to LlamaBot AI.
  belongs_to :human_chat_message, class_name: 'ChatMessage', optional: true

  # This is LlamaBot's response to the user's message.
  belongs_to :ai_chat_message, class_name: 'ChatMessage', optional: true

  def is_current_version?
    page&.current_version_id == id
  end
end