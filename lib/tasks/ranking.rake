require 'rubygems'
require 'json'

namespace :profile do

  desc 'Flatten a user profile'

  task ranking: :environment do

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

    #worker = flatten_user_profile('worker')
    #puts "Worker: #{worker.inspect}"

    customer = User.where(username: 'customer').first
    customer_profile = customer.profile.flatten
    puts "Customer:" #{customer_profile.inspect}"

    results = []
    User.where(worker: true).each do |worker|
      worker_profile = worker.profile.flatten
      rank = rank_match_by_profile(customer_profile, worker_profile)
      puts "Worker: #{worker.username} => #{rank}"
      results.push({ id: worker.id, rank: rank})
    end

    puts "Results:"
    (results.sort { |x,y| y[:rank] <=> x[:rank] }).each do |worker|
      puts "  #{worker[:rank]}  #{User.find(worker[:id]).username}"
    end

  end
end
