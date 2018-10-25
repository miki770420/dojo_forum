class CategoriesController < ApplicationController


  def show
    @categories = Category.all
    @category = Category.find(params[:id])
    if current_user
      @q = @category.posts.published.all_user.or(@category.posts.published.friend_post(current_user)).or(@category.posts.published.my_post(current_user)).ransack(params[:q])
    else
      @q = @category.posts.published.all_user.ransack(params[:q])
    end
    @posts = @q.result(distinct: true).page(params[:page]).per(20)
  end

end
