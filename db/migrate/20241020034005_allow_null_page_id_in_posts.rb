class AllowNullPageIdInPosts < ActiveRecord::Migration[7.2]
  def change
    change_column_null :posts, :page_id, true
  end
end