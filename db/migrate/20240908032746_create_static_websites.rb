class CreateStaticWebsites < ActiveRecord::Migration[7.2]
  def change
    create_table :static_websites do |t|
      t.references :organization, null: false, foreign_key: true
      t.string :name
      t.string :slug

      t.timestamps
    end
    add_index :static_websites, :slug, unique: true
  end
end
