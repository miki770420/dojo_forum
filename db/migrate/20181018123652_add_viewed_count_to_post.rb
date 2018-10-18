class AddViewedCountToPost < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :viewed_count, :integer, :default => 0
  end
end
