class AddFeedbackToMessageReactions < ActiveRecord::Migration[7.2]
    def change
      add_column :message_reactions, :feedback, :text
    end
  end 