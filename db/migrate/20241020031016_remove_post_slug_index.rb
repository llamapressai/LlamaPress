class RemovePostSlugIndex < ActiveRecord::Migration[7.2]
  def change
    remove_index :posts, :slug
  end
end
