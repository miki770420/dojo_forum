class UsersController < ApplicationController
  before_action :authenticate_owner, only: [:edit, :update]
  before_action :authenticate_user!

  def show
    @user = User.find(params[:id])
    @published_posts = @user.posts.where( :draft => false ).page(params[:published_page]).per(20)
    @draft_posts = @user.posts.where( :draft => true ).page(params[:draft_page]).per(20)
    @replies = @user.replies.page(params[:replies_page]).per(20)
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = "user was successfully updated"
      redirect_to user_path(@user)
    else
      flash.now[:alert] = "user was failed to update"
      render :edit
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :description, :avatar)
  end

  def authenticate_owner
    @user = User.find(params[:id])
    unless current_user == @user
      flash[:alert] = "Not allow!"
      redirect_to user_path(@user)
    end
  end
end
