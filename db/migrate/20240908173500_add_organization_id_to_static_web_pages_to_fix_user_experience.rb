class AddOrganizationIdToStaticWebPagesToFixUserExperience < ActiveRecord::Migration[7.2]
  def change
    add_column :static_web_pages, :organization_id, :integer
    add_foreign_key :static_web_pages, :organizations, column: :organization_id, primary_key: :"id", on_delete: :nullify, optional: true
  end
end