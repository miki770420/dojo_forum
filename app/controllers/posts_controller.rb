class PostsController < ApplicationController

  def index
    @posts = Post.order(created_at: :desc)
    @post = Post.new
  end
end
