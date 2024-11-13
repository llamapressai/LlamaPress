class CreateChatConversations < ActiveRecord::Migration[7.2]
  def change
    create_table :chat_conversations do |t|
      t.string :title
      t.references :user, null: false, foreign_key: true
      t.references :site, null: false, foreign_key: true
      t.string :uuid

      t.timestamps
    end
    add_index :chat_conversations, :uuid, unique: true
  end
end
