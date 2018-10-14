class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.integer :user_id
      t.string :image
      t.string :title
      t.text :content
      t.integer :privacy, default: 0, null: false
      t.datetime :published_at
      t.datetime :replied_at
      t.boolean :draft, null: false, default: true

      t.timestamps
    end
  end
end
