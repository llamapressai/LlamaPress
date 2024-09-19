class CreateSites < ActiveRecord::Migration[7.2]
  def change
    create_table :sites do |t|
      t.references :organization, null: false, foreign_key: true
      t.string :name
      t.string :slug

      t.timestamps
    end
    add_index :sites, :slug, unique: true
  end
end
