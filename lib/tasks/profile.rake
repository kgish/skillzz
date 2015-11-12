require 'rubygems'
require 'json'

namespace :profile do

  desc 'Flatten a user profile'

  task flatten: :environment do
    def flatten_user_profile(username)
      flatten_profile(User.find_by!(username: username).profile)
    end

    def flatten_profile(profile)
      graphs = []
      graphs_1 = []
      graphs_2 = []
      graphs_3 = []
      profile.children.each do |category|
        #puts "Category: #{Category.find(category.this_id).name}"
        graphs_1.push([category.this_id])
        category.children.each do |skill|
          graphs_2.push([category.this_id, skill.this_id])
          skill.children.each do |tag|
            graphs_3.push([category.this_id, skill.this_id, tag.this_id])
          end
        end
      end
      graphs.push(graphs_1)
      graphs.push(graphs_2)
      graphs.push(graphs_3)
      graphs.to_json
    end

    def rank_match_by_profile(customer, worker)
      customer_profile = JSON.parse(customer)
      worker_profile = JSON.parse(worker)
      #puts "rank_match_by_profile()"
      rank_total = 0
      0.upto 2 do |n|
        #puts "match_rank: #{n}"
        #puts customer_profile[n-1].inspect
        #puts worker_profile[n-1].inspect
        intersection = customer_profile[n] & worker_profile[n]
        #puts "intersection = #{intersection.inspect}"
        rank = (n + 1) * intersection.length
        #puts "rank = #{rank}"
        rank_total = rank + 1
        #puts "rank_total = #{rank_total}"
      end
      #puts "rank_match_by_profile() => #{rank_total}"
      rank_total
    end

    worker = flatten_user_profile('worker')
    #puts "Worker: #{worker.inspect}"

    customer = flatten_user_profile('customer')
    #puts "Customer:" #{customer.inspect}"

    rank = rank_match_by_profile(customer, worker)
    puts "Rank: #{rank}"

  end
end
