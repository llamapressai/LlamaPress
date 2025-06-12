class AddWordpressPageId < ActiveRecord::Migration[7.2]
    def change
      add_column :pages, :wordpress_page_id, :integer
    end
  end