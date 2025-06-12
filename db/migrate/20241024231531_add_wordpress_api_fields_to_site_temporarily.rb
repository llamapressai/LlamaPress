class AddWordpressApiFieldsToSiteTemporarily < ActiveRecord::Migration[7.2]
    def change
      add_column :sites, :wordpress_api_encoded_token, :string
    end
  end