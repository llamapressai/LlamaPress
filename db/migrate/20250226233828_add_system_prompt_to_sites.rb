class AddSystemPromptToSites < ActiveRecord::Migration[7.2]
    def change
      add_column :sites, :system_prompt, :text
    end
  end
  