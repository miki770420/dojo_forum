class UsersController < ApplicationController
  before_action :authenticate_owner, only: [:edit, :update]
  before_action :authenticate_user!
  before_action :set_user

  def show
    @published_posts = @user.posts.where( :draft => false ).page(params[:published_page]).per(20)
    @draft_posts = @user.posts.where( :draft => true ).page(params[:draft_page]).per(20)
    @replies = @user.replies.page(params[:replies_page]).per(20)
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:notice] = 'user was successfully updated'
      redirect_to user_path(@user)
    else
      flash.now[:alert] = 'user was failed to update'
      render :edit
    end
  end

  def invite
    if @user == current_user
      flash[:alert] = 'Not allow to follow yourself'
      redirect_back(fallback_location: root_path)
    elsif current_user.is_friend?(@user)
      flash[:alert] = 'You are friends'
      redirect_back(fallback_location: root_path)
    elsif current_user.is_inviting?(@user)
      flash[:alert] = 'Already invites'
      redirect_back(fallback_location: root_path)
    else
      @friendship = Friendship.create!(user: current_user, friend: @user)
      if @friendship.save
        flash[:notice] = 'Send invitation successfully'
        redirect_back(fallback_location: root_path)
      else
        flash[:alert] = @friendship.errors.full_messages.to_sentence if @friendship.errors.any?
        redirect_back(fallback_location: root_path)
      end
    end
  end

   def accept
    @friendship = Friendship.find_by(user: @user , friend: current_user)
    @friendship.status = 'accept'
    @friendship.save
    flash[:notice] = 'You are friends now!'
    redirect_back(fallback_location: root_path)
  end

  def ignore
    @friendship = Friendship.find_by(user: @user , friend: current_user)
    @friendship.status = 'ignore'
    @friendship.save
    flash[:notice] = 'Ignore the invitation!'
    redirect_back(fallback_location: root_path)
  end
  

  private
  def user_params
    params.require(:user).permit(:name, :description, :avatar)
  end

  def authenticate_owner
    @user = User.find(params[:id])
    unless current_user == @user
      flash[:alert] = 'Not allow!'
      redirect_to user_path(@user)
    end
  end

  def set_user
    @user = User.find(params[:id])
  end


end
