class AddReactionToPageHistory < ActiveRecord::Migration[7.2]
    def change
      add_column :message_reactions, :page_history_id, :bigint
      add_foreign_key :message_reactions, :page_histories, column: :page_history_id, on_delete: :nullify
      add_index :message_reactions, :page_history_id
    end
  end