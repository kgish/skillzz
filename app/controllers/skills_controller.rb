class SkillsController < ApplicationController
  def index
    @skills = Skill.all
  end

  def new
    @skill = Skill.new
  end

  def create
    @skill = Skill.new(skill_params)

    if @skill.save
      flash[:notice] = "Skill has been created."
      redirect_to @skill
    else
      flash.now[:alert] = "Skill has not been created."
      render "new"
    end
  end

  def show
    @skill = Skill.find(params[:id])
  end

  def edit
    @skill = Skill.find(params[:id])
  end

  def update
    @skill = Skill.find(params[:id])
    @skill.update(skill_params)

    if @skill.update(skill_params)
      flash[:notice] = "Skill has been updated."
      redirect_to @skill
    else
      flash.now[:alert] = "Skill has not been updated."
      render "edit"
    end
  end

  def destroy
    @skill = Skill.find(params[:id])
    @skill.destroy

    flash[:notice] = "Skill has been deleted."
    redirect_to skills_path
  end

  private

  def skill_params
    params.require(:skill).permit(:name)
  end

end
