class SkillsController < ApplicationController
  def index
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

  private

  def skill_params
    params.require(:skill).permit(:name)
  end

end
