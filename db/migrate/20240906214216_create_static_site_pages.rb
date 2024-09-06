class CreateStaticSitePages < ActiveRecord::Migration[7.1]
  def change
    create_table :static_site_pages do |t|
      t.references :static_site, null: false, foreign_key: true
      t.string :content
      t.string :slug
      t.string :prompt

      t.timestamps
    end
  end
end
