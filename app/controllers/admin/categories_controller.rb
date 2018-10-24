class Admin::CategoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin

  def index
    @categories = Category.all
    if params[:id]
      @category = Category.find(params[:id])
    else
      @category = Category.new
    end
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      flash[:notice] = "category was successfully created"
      redirect_to admin_categories_path
    else
      @categories = Category.all
      render :index
    end
  end

  def update
    @category = Category.find(params[:id])
    if @category.update(category_params)
      redirect_to admin_categories_path
      flash[:notice] = "category was successfully updated"
    else
      @categories = Category.all
      render :index
    end
  end

  def destroy
    @category = Category.find(params[:id])

    if @category.posts.count == 0
      @category.destroy
      flash[:notice] = "category was successfully deleted"
      redirect_to admin_categories_path
    else
      flash[:alert] = "category cannot be delete, it has posts already!"
      redirect_to admin_categories_path
    end
  end


  private 
  def authenticate_admin
      unless current_user.admin?
        flash[:alert] = "Not allow!"
        redirect_to root_path
      end
  end

  def category_params
    params.require(:category).permit(:name)
  end
end
