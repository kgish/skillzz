class CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :edit, :update]

  def index
    @categories = policy_scope(Category)
  end

  def show
    authorize @category, :show?
  end

  def edit
    authorize @category, :edit?
  end

  def update
    authorize @category, :update?

    if @category.update(category_params)
      flash[:notice] = "Category has been updated."
      redirect_to @category
    else
      flash.now[:alert] = "Category has not been updated."
      render "edit"
    end
  end

  private

    def category_params
      params.require(:category).permit(:name, :description)
    end

    def set_category
      @category = Category.find(params[:id])
      rescue ActiveRecord::RecordNotFound
      flash[:alert] = "The category you were looking for could not be found."
      redirect_to categories_path
    end

end
