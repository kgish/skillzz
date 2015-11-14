class Customer::ResultController < ApplicationController
  # TODO: For the time-being checks disabled for authorized and policy.
  skip_after_action :verify_authorized, :verify_policy_scoped

  def show
    @user = User.find(params[:search_id])
    @profile = Profile.find(params[:id])
    # TODO
    # :id => profile_id (for multiple profiles -- later)
    # TODO
    # Authorize (current_user MUST equal user)
    @results = rankings
  end

  private

    def rank_match_by_profile(customer, worker)
      customer_profile = JSON.parse(customer)
      worker_profile = JSON.parse(worker)
      categories = []
      skills = []
      tags = []
      0.upto 2 do |n|
        intersection = customer_profile[n] & worker_profile[n]
        if intersection.length
          intersection.each do |arr|
            case n
              when 0
                categories << Category.find(arr[0]).name
              when 1
                skills << Skill.find(arr[1]).name
              when 2
                tags << Tag.find(arr[2]).name
            end
          end
        end
      end
      rank = categories.length + 2 * skills.length + 3 * tags.length
      return rank, categories, skills, tags
    end

    def rankings
      customer_profile = @user.profile.flatten

      results = []
      # Search through all of the workers.
      User.where(worker: true).each do |worker|
        worker_profile = worker.profile.flatten
        rank, categories, skills, tags = rank_match_by_profile(customer_profile, worker_profile)
        if rank > 0
          results.push({ rank: rank, user: User.find_by!(id: worker.id), categories: categories, skills: skills, tags: tags })
        end
      end

      # Sort results by RANK in descending order.
      results.sort! { |x,y| y[:rank] <=> x[:rank] }
    end

end
