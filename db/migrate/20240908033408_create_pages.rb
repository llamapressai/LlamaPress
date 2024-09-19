class CreatePages < ActiveRecord::Migration[7.2]
  def change
    create_table :pages do |t|
      t.references :site, null: false, foreign_key: true
      t.text :content
      t.string :slug
      t.string :prompt

      t.timestamps
    end
  end
end
