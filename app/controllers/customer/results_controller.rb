class Customer::ResultsController < ApplicationController
  before_action :set_user, only: [:index]

  # TODO: For the time-being checks disabled for authorized and policy.
  skip_after_action :verify_authorized, :verify_policy_scoped

  def index
  end

  private

    def set_user
      @user = current_user
      # TODO
      # Authorize (current_user MUST equal user)
    end

end
