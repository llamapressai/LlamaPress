class CreateStaticWebPageHistories < ActiveRecord::Migration[7.2]
  def change
    create_table :static_web_page_histories do |t|
      t.text :content
      t.references :static_web_page, null: false, foreign_key: true
      t.text :prompt
      t.text :user_message

      t.timestamps
    end
  end
end
