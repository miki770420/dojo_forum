class Post < ApplicationRecord

  belongs_to :user
  has_many :post_categories, dependent: :destroy
  has_many :categories, through: :post_categories, source: :category
  has_many :replies, dependent: :destroy
  has_many :collections, dependent: :destroy
  has_many :collected_users, through: :collections, source: :user

  mount_uploader :image, PostUploader

  enum privacy: {
    all_user:     0, # 公開
    only_friend:  1, # 好友限定
    only_me:      2, # 僅限自己
  }

  scope :published, -> {
    where( draft: false )
  }

  scope :draft, -> {
    where( draft: true )
  }

  scope :friend_post, -> (user){
    friends = user.friends.where('friendships.status = ?', 'accept')
    only_friend.where('user_id in (?)', friends.map{|x|x.id})
  }

  scope :my_post, ->(user){
    where('user_id = ?', user.id).only_me
  }

  def is_collected?(user)
    self.collected_users.include?(user)
  end

  def is_viewable?(viewer)
    if self.privacy == 'all_user'
      return true
    elsif self.privacy == 'only_me' && self.user == viewer
      return true
    elsif viewer.present?
      if viewer.friends.include?(self.user)
        friendship = viewer.friendships.find_by(friend: self.user)
        friendship.status == 'accept' if friendship.present?
      else
        return false
      end
    else
      return false
    end
  end

end
