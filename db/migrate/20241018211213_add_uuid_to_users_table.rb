class AddUuidToUsersTable < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :public_id, :string
    add_index :users, :public_id, unique: true
  end
end