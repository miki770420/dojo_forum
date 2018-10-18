class Post < ApplicationRecord

  belongs_to :user
  has_many :post_categories, dependent: :destroy
  has_many :categories, through: :post_categories, source: :category
  has_many :replies, dependent: :destroy

  mount_uploader :image, PostUploader
end
