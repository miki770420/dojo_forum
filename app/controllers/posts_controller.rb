class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  def index
    @posts = Post.order(created_at: :desc)
    @post = Post.new
    @users = User.all
  end

  def new
    @post = Post.new
  end

  def show
  end

  def edit
  end

  def create
    @post = Post.new(post_params)
    @post.user = current_user
    @post.published_at = Time.zone.now if publishing?
    @post.published_at = nil if save_as_draft?
    if @post.save
      if publishing?
        @post.draft = false
        @post.save
        flash[:notice] = "post was successfully created"
      else
        flash[:notice] = "post was saved as draft"
      end
      redirect_to post_path(@post)
    else
      flash.now[:alert] = @post.errors.full_messages.to_sentence if @post.errors.any?
      render new_post_path(@post)
    end
  end

  def update
    @post.published_at = Time.zone.now if publishing?
    @post.published_at = nil if save_as_draft?
    if @post.update(post_params)
      if publishing? && @post.draft == true
        @post.draft = false
        @post.save
        flash[:notice] = "post was successfully created"
      else save_as_draft?
        @post.draft = true
        @post.save
        flash[:notice] = "post was successfully updated"
      end
      redirect_to post_path(@post)
    else
      flash.now[:alert] = @post.errors.full_messages.to_sentence if @post.errors.any?
      render :edit
    end
  end

  def destroy
    if @post.user == current_user || current_user.admin?
      @post.destroy
      flash[:notice] = "post was successfully deleted"
      redirect_to posts_path
    else
      flash[:alert] = 'Not allowed!'
      redirect_back(fallback_location: root_path)
    end
  end

private
  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :content, :image, :draft)
  end

  def publishing?
    params[:commit] == 'Publish'
  end

   def save_as_draft?
    params[:commit] == 'Save as Draft'
  end

end
