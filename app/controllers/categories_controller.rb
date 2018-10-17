class CategoriesController < ApplicationController


  def show
    @categories = Category.all
    @category = Category.find(params[:id])
    @posts = @category.posts.all
  end

end
