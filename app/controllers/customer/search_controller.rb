class Customer::SearchController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]

  # TODO: For the time-being checks disabled for authorized and policy.
  skip_after_action :verify_authorized, :verify_policy_scoped

  def show
  end

  def edit
  end

  def update
  end

  private

    def set_user
      @user = User.find(params[:id])
      # TODO
      # Authorize (current_user MUST equal user)
    end

end
