class AddOrganizationIdToPagesToFixUserExperience < ActiveRecord::Migration[7.2]
  def change
    add_column :pages, :organization_id, :integer
    add_foreign_key :pages, :organizations, column: :organization_id, primary_key: :"id", on_delete: :nullify, optional: true
  end
end