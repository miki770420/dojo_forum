class Post < ApplicationRecord

  belongs_to :user
  has_many :post_categories, dependent: :destroy
  has_many :categories, through: :post_categories, source: :category
  has_many :replies, dependent: :destroy
  has_many :collections, dependent: :destroy
  has_many :collected_users, through: :collections, source: :user

  mount_uploader :image, PostUploader

  def is_collected?(user)
    self.collected_users.include?(user)
  end
end
