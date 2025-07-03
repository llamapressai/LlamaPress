class DropSnippetsTable < ActiveRecord::Migration[7.2]
  def change
    # Remove the code_snippets column from sites table
    remove_column :sites, :code_snippets, :text
    
    # Drop the snippets table
    drop_table :snippets do |t|
      t.string :name
      t.string :content
      t.bigint :site_id, null: false
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
      t.index [:site_id], name: "index_snippets_on_site_id"
    end
  end
end
