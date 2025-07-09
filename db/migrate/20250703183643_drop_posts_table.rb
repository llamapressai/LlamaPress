class DropPostsTable < ActiveRecord::Migration[7.2]
  def change
    drop_table :posts do |t|
      t.string :title
      t.string :slug
      t.text :content
      t.references :page, null: true, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end
