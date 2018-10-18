class AddReplyCountToPost < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :replies_count, :integer, :default => 0
  end
end
