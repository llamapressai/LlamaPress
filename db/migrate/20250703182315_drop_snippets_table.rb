class DropSnippetsTable < ActiveRecord::Migration[7.1]
  def change
    remove_column :sites, :code_snippets, :text, if_exists: true
    drop_table :snippets, if_exists: true
  end
end
