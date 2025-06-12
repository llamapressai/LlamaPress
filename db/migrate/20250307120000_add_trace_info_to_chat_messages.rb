class AddTraceInfoToChatMessages < ActiveRecord::Migration[7.2]
    def change
      add_column :chat_messages, :trace_id, :string
      add_column :chat_messages, :trace_url, :string
      add_index :chat_messages, :trace_id
    end
  end 