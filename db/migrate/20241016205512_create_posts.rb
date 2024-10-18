class CreatePosts < ActiveRecord::Migration[7.2]
  def change
    create_table :posts do |t|
      t.string :title
      t.string :slug
      t.text :content
      t.references :page, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
    add_index :posts, :slug, unique: true
  end
end
