class CreateSubmissions < ActiveRecord::Migration[7.2]
  def change
    create_table :submissions do |t|
      t.jsonb :data
      t.references :site, null: false, foreign_key: true

      t.timestamps
    end
  end
end
