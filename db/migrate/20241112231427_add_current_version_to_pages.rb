class AddCurrentVersionToPages < ActiveRecord::Migration[7.2]
  def change
    add_column :pages, :current_version_id, :integer
    add_index :pages, :current_version_id
  end
end
