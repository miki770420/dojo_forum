class FeedsController < ApplicationController

  def index
    @popular_users = User.order(replies_count: :desc).limit(10)
    @popular_posts = Post.order(replies_count: :desc).limit(10)
  end

end
