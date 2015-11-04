class Admin::CategoriesController < Admin::ApplicationController
  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)

    if @category.save
      flash[:notice] = "Category has been created."
      redirect_to @category
    else
      flash.now[:alert] = "Category has not been created."
      render "new"
    end
  end

  def destroy
    @category = Category.find(params[:id])
    @category.destroy

    flash[:notice] = "Category has been deleted."
    redirect_to categories_path
  end

  private

  def category_params
    params.require(:category).permit(:name, :description)
  end


end
