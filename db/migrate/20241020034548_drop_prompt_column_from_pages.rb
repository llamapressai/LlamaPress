class DropPromptColumnFromPages < ActiveRecord::Migration[7.2]
  def change
    remove_column :pages, :prompt
  end
end