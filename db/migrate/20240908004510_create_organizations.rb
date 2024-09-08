class CreateOrganizations < ActiveRecord::Migration[7.2]
  def change
    create_table :organizations do |t|
      t.string :name
      t.string :city
      t.string :phone
      t.text :notes
      t.string :state
      t.string :street_address
      t.string :zip_code
      t.string :email

      t.timestamps
    end
  end
end
