class AddDefaultSiteToUser < ActiveRecord::Migration[7.2]
  def change
    add_reference :users, :default_site, foreign_key: { to_table: :sites }, index: true
  end
end