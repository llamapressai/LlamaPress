class AddHomePageIdToSites < ActiveRecord::Migration[7.2]
  def change
    add_reference :sites, :home_page, foreign_key: { to_table: :pages }
  end
end