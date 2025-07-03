class DropDeprecatedTables < ActiveRecord::Migration[7.2]
  def change
    # Drop hello_dolly_greetings table
    drop_table :hello_dolly_greetings do |t|
      t.string :title
      t.text :content
      t.timestamps
    end
    
    # Drop leads table
    drop_table :leads do |t|
      t.string :email, null: false
      t.string :url
      t.text :notes
      t.timestamps
      t.index :email, unique: true
    end
    
    # Drop message_reactions table (remove foreign key constraints first)
    remove_foreign_key :message_reactions, :page_histories if foreign_key_exists?(:message_reactions, :page_histories)
    remove_foreign_key :message_reactions, :users if foreign_key_exists?(:message_reactions, :users)
    
    drop_table :message_reactions do |t|
      t.bigint :user_id
      t.string :reaction_type, null: false
      t.text :feedback
      t.bigint :page_history_id
      t.timestamps
      t.index :page_history_id
      t.index :user_id
    end
  end
end
