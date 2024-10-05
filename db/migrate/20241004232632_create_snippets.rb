class CreateSnippets < ActiveRecord::Migration[7.2]
  def change
    create_table :snippets do |t|
      t.string :name
      t.string :content
      t.references :site, null: false, foreign_key: true

      t.timestamps
    end
  end
end
