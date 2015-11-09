class SkillsAllController < ApplicationController
  # TODO: For the time-being checks disabled for authorized and policy.
  skip_after_action :verify_authorized, :verify_policy_scoped

  def index
    @skills = Skill.order(:name)
  end
end
