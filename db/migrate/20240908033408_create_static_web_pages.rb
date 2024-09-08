class CreateStaticWebPages < ActiveRecord::Migration[7.2]
  def change
    create_table :static_web_pages do |t|
      t.references :static_web_site, null: false, foreign_key: true
      t.text :content
      t.string :slug
      t.string :prompt

      t.timestamps
    end
  end
end
