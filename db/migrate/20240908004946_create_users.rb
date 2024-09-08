class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.string :email
      t.string :phone
      t.string :first_name
      t.string :last_name
      t.references :organization, null: false, foreign_key: true

      t.timestamps
    end
    add_index :users, :email, unique: true
    add_index :users, :phone
  end
end
