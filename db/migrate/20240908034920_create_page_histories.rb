class CreatePageHistories < ActiveRecord::Migration[7.2]
  def change
    create_table :page_histories do |t|
      t.text :content
      t.references :page, null: false, foreign_key: true
      t.text :prompt
      t.text :user_message

      t.timestamps
    end
  end
end
