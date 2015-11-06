class TagsController < ApplicationController
  def remove
    @skill = Skill.find(params[:skill_id])
    @tag = Tag.find(params[:id])
    authorize @skill, :tag?
    @skill.tags.destroy(@tag)
    head :ok
  end
end
