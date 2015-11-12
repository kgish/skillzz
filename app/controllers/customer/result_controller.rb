class Customer::ResultController < ApplicationController
  before_action :set_user_and_profile, only: [:show]

  # TODO: For the time-being checks disabled for authorized and policy.
  skip_after_action :verify_authorized, :verify_policy_scoped

  def show
    @results = rankings
  end

  private

    def set_user_and_profile
      @user = User.find(params[:search_id])
      @profile = Profile.find(params[:id])
      # TODO
      # :id => profile_id (for multiple profiles -- later)
      # TODO
      # Authorize (current_user MUST equal user)
    end

    def rank_match_by_profile(customer, worker)
      customer_profile = JSON.parse(customer)
      worker_profile = JSON.parse(worker)
      rank_total = 0
      0.upto 2 do |n|
        intersection = customer_profile[n] & worker_profile[n]
        rank = (n + 1) * intersection.length
        rank_total = rank + 1
      end
      rank_total
    end

    def rankings
      customer_profile = @user.profile.flatten

      results = []
      # Search through all of the workers.
      User.where(worker: true).each do |worker|
        worker_profile = worker.profile.flatten
        rank = rank_match_by_profile(customer_profile, worker_profile)
        results.push({ rank: rank, user: User.find_by!(id: worker.id) })
      end

      # Sort results by RANK in descending order.
      results.sort! { |x,y| y[:rank] <=> x[:rank] }
    end

end
