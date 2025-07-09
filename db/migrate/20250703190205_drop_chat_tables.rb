class DropChatTables < ActiveRecord::Migration[7.2]
  def change
    # Remove foreign key constraints first
    remove_foreign_key :page_histories, :chat_messages, column: :human_chat_message_id if foreign_key_exists?(:page_histories, :chat_messages, column: :human_chat_message_id)
    remove_foreign_key :page_histories, :chat_messages, column: :ai_chat_message_id if foreign_key_exists?(:page_histories, :chat_messages, column: :ai_chat_message_id)
    if table_exists?(:message_reactions)
      remove_foreign_key :message_reactions, :chat_messages if foreign_key_exists?(:message_reactions, :chat_messages)
    end
    remove_foreign_key :chat_messages, :chat_conversations if foreign_key_exists?(:chat_messages, :chat_conversations)
    remove_foreign_key :chat_conversations, :users if foreign_key_exists?(:chat_conversations, :users)
    remove_foreign_key :chat_conversations, :sites if foreign_key_exists?(:chat_conversations, :sites)
    remove_foreign_key :chat_conversations, :pages if foreign_key_exists?(:chat_conversations, :pages)
    
    # Remove indexes
    remove_index :page_histories, :human_chat_message_id if index_exists?(:page_histories, :human_chat_message_id)
    remove_index :page_histories, :ai_chat_message_id if index_exists?(:page_histories, :ai_chat_message_id)
    if table_exists?(:message_reactions)
      remove_index :message_reactions, [:chat_message_id, :user_id] if index_exists?(:message_reactions, [:chat_message_id, :user_id])
      remove_index :message_reactions, :chat_message_id if index_exists?(:message_reactions, :chat_message_id)
    end
    
    # Remove columns that reference chat tables
    remove_column :page_histories, :human_chat_message_id, :bigint, if_exists: true
    remove_column :page_histories, :ai_chat_message_id, :bigint, if_exists: true
    if table_exists?(:message_reactions)
      remove_column :message_reactions, :chat_message_id, :bigint, if_exists: true
    end
    
    # Drop the chat tables
    drop_table :message_reactions, if_exists: true
    drop_table :chat_messages, if_exists: true do |t|
      t.text :content
      t.integer :sender
      t.bigint :user_id, null: false
      t.bigint :chat_conversation_id, null: false
      t.string :uuid
      t.string :trace_id
      t.string :trace_url
      t.timestamps
    end
    
    drop_table :chat_conversations, if_exists: true do |t|
      t.string :title
      t.bigint :user_id, null: false
      t.bigint :site_id
      t.bigint :page_id
      t.string :uuid
      t.timestamps
    end
  end
end
