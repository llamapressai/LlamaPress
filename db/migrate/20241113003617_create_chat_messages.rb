class CreateChatMessages < ActiveRecord::Migration[7.2]
  def change
    create_table :chat_messages do |t|
      t.text :content
      t.integer :sender
      t.references :user, null: false, foreign_key: true
      t.references :chat_conversation, null: false, foreign_key: true
      t.string :uuid

      t.timestamps
    end
    add_index :chat_messages, :uuid, unique: true
  end
end
