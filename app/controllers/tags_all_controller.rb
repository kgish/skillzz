class TagsAllController < ApplicationController
  # TODO: For the time-being checks disabled for authorized and policy.
  skip_after_action :verify_authorized, :verify_policy_scoped

  def index
    @tags = Tag.order(:name).paginate(:page => params[:page])
  end
end
