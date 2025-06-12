class AddHumanMessageAndAiMessageToPageHistory < ActiveRecord::Migration[7.2]
    def change
      add_column :page_histories, :human_chat_message_id, :bigint
      add_column :page_histories, :ai_chat_message_id, :bigint
  
      add_index :page_histories, :human_chat_message_id
      add_index :page_histories, :ai_chat_message_id
  
      add_foreign_key :page_histories, :chat_messages, column: :human_chat_message_id
      add_foreign_key :page_histories, :chat_messages, column: :ai_chat_message_id
    end
  end
  