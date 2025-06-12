class CreateLeads < ActiveRecord::Migration[7.0]
  def change
    create_table :leads do |t|
      t.string :email, null: false
      t.string :url
      t.timestamps
    end
    
    add_index :leads, :email, unique: true
  end
end
