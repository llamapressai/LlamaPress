class AddLlamabotAgentToSite < ActiveRecord::Migration[7.2]
    def change
      add_column :sites, :llamabot_agent_name, :string
    end
  end