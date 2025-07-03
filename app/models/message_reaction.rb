class MessageReaction < ApplicationRecord
  belongs_to :page_history
  belongs_to :user, optional: true
  
  validates :reaction_type, inclusion: { in: ['up', 'down'] }
end