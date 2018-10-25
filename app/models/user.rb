class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates_presence_of :name, :email
  validates_uniqueness_of :name, :email

  has_many :posts, dependent: :destroy
  has_many :replies, dependent: :destroy
  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships
  has_many :inverse_friendships, class_name: "Friendship", foreign_key: "friend_id"
  has_many :inviters, through: :inverse_friendships, source: :user
  has_many :collections, dependent: :destroy
  has_many :collected_posts, through: :collections, source: :post

  mount_uploader :avatar, AvatarUploader

  def admin?
    self.role == "admin"
  end

  def is_friend?(user)
    if self.friendships.find_by(friend: user).nil?
      if self.inverse_friendships.find_by(user: user).nil?
        return false
      else
        inviter = self.inverse_friendships.find_by(user: user)
        inviter.status == 'accept'
      end
    else
      inviting = self.friendships.find_by(friend: user)
      inviting.status == 'accept'
    end
  end

  def is_inviting?(user)
    friendship = self.friendships.find_by(friend: user)
    friendship.status == 'wait' if friendship.present?
  end

  def is_invited?(user)
    friendship = self.inverse_friendships.find_by(user: user)
    friendship.status == 'wait' if friendship.present?
  end

  def is_ignore?(user)
    friendship = self.inverse_friendships.find_by(user: user)
    friendship.status == 'ignore' if friendship.present?
  end

  def is_accept?(user)
    friendship = self.inverse_friendships.find_by(user: user)
    friendship.status == 'accept' if friendship.present?
  end
end
