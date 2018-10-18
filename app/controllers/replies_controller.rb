class RepliesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_reply, only: [:edit, :update, :destroy]

  def create
    @post = Post.find(params[:post_id])
    @reply = @post.replies.build(reply_params)
    @reply.user = current_user
    @post.replied_at = Time.zone.now
    if @reply.save
      @post.save
      redirect_to post_path(@post)
      flash[:notice] = "reply successfully"
    else @reply.save!
      flash[:alert] = "reply fail to create"
      render post_path(@post)
    end
  end

  def edit
    @post = Post.find(params[:post_id])
    @reply = @post.replies.find(params[:id])
    if @reply.user == current_user
    else
      flash[:alert] = "Not allow!"
      render post_path(@post)
    end
  end

  def update
    @post = Post.find(params[:post_id])
    @reply = @post.replies.find(params[:id])
    if @reply.user == current_user
      if @reply.update(reply_params)
        if @reply.save
          redirect_to post_path(@post)
          flash[:notice] = "reply was successfully updated"
        else
          flash[:alert] = "reply fail to update"
          render post_path(@post)
        end
      else
        flash.now[:alert] = @reply.errors.full_messages.to_sentence if @reply.errors.any?
        render post_path(@post)
      end
    else
      flash[:alert] = "Not allow!"
      redirect_to post_path(@post)
    end
  end

  def destroy
    @post = Post.find(params[:post_id])
    @reply = @post.replies.find(params[:id])
    if @reply.user == current_user || current_user.admin?
      @reply.destroy
      flash[:notice] = "reply was successfully deleted"
      redirect_to post_path(@post)
    else
      flash[:alert] = 'Not allowed!'
      redirect_back(fallback_location: root_path)
    end
  end

  private

  def reply_params
    params.require(:reply).permit(:comment)
  end

  def set_reply
    @post = Post.find(params[:post_id])
    @reply = @post.replies.find(params[:id])
  end
end
