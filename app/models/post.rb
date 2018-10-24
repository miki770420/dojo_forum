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

  def is_viewable?(viewer)
    if self.privacy == 0
      return true
    elsif self.privacy == 2 && self.user == viewer
      return true
    elsif viewer.friends.include?(self.user)
      friendship = viewer.friendships.find_by(friend: self.user)
      friendship.status == 'accept' if friendship.present?
    else
      return false
    end
  end

end
