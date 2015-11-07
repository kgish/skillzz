class SkillsController < ApplicationController
  before_action :set_category
  before_action :set_skill, only: [:show, :edit, :update, :destroy]

  def index
    @skills = Skill.all
  end

  def new
    @skill = @category.skills.build
    authorize @skill, :create?
  end

  def create
    @skill = @category.skills.new

    whitelisted_params = skill_params
    unless policy(@skill).tag?
      whitelisted_params.delete(:tag_names)
    end

    @skill.attributes = whitelisted_params

    @skill.author = current_user
    authorize @skill, :create?

    if @skill.save
      flash[:notice] = "Skill has been created."
      redirect_to [@category, @skill]
    else
      flash.now[:alert] = "Skill has not been created."
      render "new"
    end
  end

  def show
    authorize @skill, :show?
  end

  def edit
    authorize @skill, :update?
  end

  def update
    authorize @skill, :update?

    if @skill.update(skill_params)
      flash[:notice] = "Skill has been updated."
      redirect_to [@category, @skill]
    else
      flash.now[:alert] = "Skill has not been updated."
      render "edit"
    end
  end

  def destroy
    authorize @skill, :destroy?
    @skill.destroy

    flash[:notice] = "Skill has been deleted."
    redirect_to @category
  end

  def search
    authorize @category, :show?
    if params[:search].present?
      @skills = @category.skills.search(params[:search])
    else
      @skills = @category.skills
    end
    render "categories/show"
  end

  private

    def skill_params
      params.require(:skill).permit(:name, :description, :tag_names)
    end

    def set_skill
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
