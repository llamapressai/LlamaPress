class AddTutorialStepToUser < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :tutorial_step, :integer, default: 0
  end
end