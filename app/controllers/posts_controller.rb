class PostsController < ApplicationController
  before_action :authenticate_user!, :except => [:index]
  before_action :set_post, only: [:show, :edit, :update, :destroy, :collect, :uncollect]

  def index
    if current_user
      @q = Post.published.all_user.or(Post.published.friend_post(current_user)).or(current_user.posts.published.only_me).ransack(params[:q])
    else
      @q = Post.published.all_user.ransack(params[:q])
    end
    @posts = @q.result(distinct: true).page(params[:page]).per(20)
    @post = Post.new
    @categories = Category.all
  end

  def new
    @post = Post.new
    @categories = Category.all
  end

  def show
    if @post.is_viewable?(current_user)
      @replies = @post.replies.page(params[:page]).per(20)
      @reply = Reply.new
      @post.viewed_count += 1
      @post.save!
    else
      flash[:alert] = "You are not allow to view!"
      redirect_back(fallback_location: root_path)
    end
  end

  def edit
    @categories = Category.all
  end

  def create
    @post = Post.new(post_params)
    @post.user = current_user
    @post.published_at = Time.zone.now if publishing?
    @post.published_at = nil if save_as_draft?
    if @post.save
      if publishing?
        can_publish?
      else
        flash[:notice] = "post was saved as draft"
        redirect_to post_path(@post)
      end
    else
      flash.now[:alert] = @post.errors.full_messages.to_sentence if @post.errors.any?
      render new_post_path(@post)
    end
  end

  def update
    @post.published_at = Time.zone.now if publishing?
    @post.published_at = nil if save_as_draft?
    if @post.update(post_params)
      if publishing?
        can_publish?
      else save_as_draft?
        @post.draft = true
        @post.save
        flash[:notice] = "post was successfully updated"
        redirect_to post_path(@post)
      end
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

  def collect
    collect = @post.collections.create!(user: current_user)
    if collect.save
      respond_to do |format|
        format.js { flash.now[:notice] = "collect post successfully" }
      end
    else
      flash[:alert] = "collect post failed"
      redirect_back(fallback_location: root_path)
    end
  end

  def uncollect
    collects = Collection.where(post: @post, user: current_user)
    if collects.destroy_all
      flash[:notice] = "uncollect post successfully"
    else
      flash[:alert] = "uncollect post failed"
      redirect_back(fallback_location: root_path)
    end
    respond_to do |format|
      format.js
    end
  end

private
  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :content, :image, :draft, :privacy, category_ids:[])
  end

  def publishing?
    params[:commit] == 'Publish'
  end

   def save_as_draft?
    params[:commit] == 'Save as Draft'
  end

  def can_publish?
    if @post.title.empty? || @post.content.empty? || @post.categories.empty?  || @post.privacy.empty?
      @post.draft = true
      @post.save
      flash[:alert] = "post title, content, category, privacy shall not empty! (post is saved as draft)"
      redirect_to edit_post_path(@post)
    else
      @post.draft = false
      @post.save
      flash[:notice] = "post was successfully created"
      redirect_to post_path(@post)
    end
  end

end
