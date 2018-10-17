class CreateReplies < ActiveRecord::Migration[5.2]
  def change
    create_table :replies do |t|
      t.integer :post_id
      t.integer :user_id
      t.text :comment

      t.timestamps
    end
  end
end
