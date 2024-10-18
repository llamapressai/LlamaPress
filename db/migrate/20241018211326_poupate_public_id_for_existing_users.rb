class PoupatePublicIdForExistingUsers < ActiveRecord::Migration[7.2]
  def up
    User.where(public_id: nil).find_each do |user|
      user.update_column(:public_id, user.id)
    end
  end

  def down
    # This migration is not reversible
  end
end