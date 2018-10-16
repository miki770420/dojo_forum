class Admin::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin
  
  def index
    @users = User.all
  end

  def update
    @user = User.find(params[:id])
    @user.update(user_params)
    if @user.save
      flash[:notice] = 'User is updated'
    else
      flash[:alert] = 'User fail to updated'
    end
    redirect_back(fallback_location: root_path)
  end

  private 
  def authenticate_admin
      unless current_user.admin?
        flash[:alert] = "Not allow!"
        redirect_to root_path
      end
  end
  
  def user_params
    params.require(:user).permit(:role)
  end
end
