class SkillsController < ApplicationController
  def index

  end

  def new
    @skill = Skill.new
  end
end
