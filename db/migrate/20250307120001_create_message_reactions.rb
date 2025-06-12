class CreateMessageReactions < ActiveRecord::Migration[7.2]
    def change
      create_table :message_reactions do |t|
        t.references :chat_message, foreign_key: true
        t.references :user, foreign_key: true
        t.string :reaction_type, null: false # 'up' or 'down'
        t.timestamps
      end
      
      # Ensure a user can only have one reaction per message
      add_index :message_reactions, [:chat_message_id, :user_id], unique: true
    end
  end 