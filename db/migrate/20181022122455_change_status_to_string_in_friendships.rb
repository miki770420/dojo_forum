class ChangeStatusToStringInFriendships < ActiveRecord::Migration[5.2]
  def change
    change_column :friendships, :status, :string, :default => "wait"
  end
end
