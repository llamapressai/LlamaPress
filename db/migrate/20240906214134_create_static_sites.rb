class CreateStaticSites < ActiveRecord::Migration[7.1]
  def change
    create_table :static_sites do |t|
      t.references :team, null: false, foreign_key: true
      t.string :name
      t.string :slug

      t.timestamps
    end
  end
end
