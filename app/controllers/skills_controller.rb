class SkillsController < ApplicationController
  def index
  end

  def new
    @skill = Skill.new
  end

  def create
    @skill = Skill.new(skill_params)
    if @skill.save
      redirect_to @skill, notice: 'Skill has been created.'
    else
      # nothing, yet
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
