class FeedsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @user_count = User.all.count
    @post_count = Post.all.where(:draft => false).count
    @replies_count = Reply.all.count
    @popular_users = User.order(replies_count: :desc).limit(10)
    @popular_posts = Post.order(replies_count: :desc).limit(10)
  end

end
