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

  mount_uploader :avatar, AvatarUploader

  def admin?
    self.role == "admin"
  end

end
