class SkillsController < ApplicationController
  before_action :set_category
  before_action :set_skill, only: [:show, :edit, :update, :destroy]

  def index
    @skills = Skill.all
  end

  def new
    # @skill = Skill.new
    @skill = @category.skills.build
  end

  def create
    # @skill = Skill.new(skill_params)
    @skill = @category.skills.build(skill_params)

    if @skill.save
      flash[:notice] = "Skill has been created."
      redirect_to [@category, @skill]
    else
      flash.now[:alert] = "Skill has not been created."
      render "new"
    end
  end

  def show
  end

  def edit
  end

  def update
    @skill.update(skill_params)

    if @skill.update(skill_params)
      flash[:notice] = "Skill has been updated."
      redirect_to [@category, @skill]
    else
      flash.now[:alert] = "Skill has not been updated."
      render "edit"
    end
  end

  def destroy
    @skill.destroy

    flash[:notice] = "Skill has been deleted."
    redirect_to @category
  end

  private

  def skill_params
    params.require(:skill).permit(:name, :description)
  end

  def set_skill
    # @skill = Skill.find(params[:id])
    @skill = @category.skills.find(params[:id])
    # TODO
    # rescue ActiveRecord::RecordNotFound
    # flash[:alert] = "The skill you were looking for could not be found."
    # redirect_to skills_path
  end

  def set_category
    @category = Category.find(params[:category_id])
  end

end
