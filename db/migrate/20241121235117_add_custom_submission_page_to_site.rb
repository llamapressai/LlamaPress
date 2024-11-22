class AddCustomSubmissionPageToSite < ActiveRecord::Migration[7.2]
  def change
    add_reference :sites, :after_submission_page, foreign_key: { to_table: :pages }
  end
end
