require 'rubygems'

#require ::File.expand_path('../../../config/environment', __FILE__)

namespace :profile do

  desc 'Flatten worker profile'

  task flatten: :environment do
    def flatten_user(username)
      graphs = []
      graphs_1 = []
      graphs_2 = []
      graphs_3 = []
      worker = User.find_by!(username: username)
      profile = worker.profile
      #puts "Profile: #{profile.inspect}"
      profile.children.each do |category|
        category_name = Category.find(category.this_id).name
        graphs_1.push([category_name])
        #puts "#{category_name}"
        category.children.each do |skill|
          skill_name = Skill.find(skill.this_id).name
          graphs_2.push([category_name, skill_name])
          #puts "-#{skill_name}"
          skill.children.each do |tag|
            tag_name = Tag.find(tag.this_id).name
            graphs_3.push([category_name, skill_name, tag_name])
            #puts "--#{tag_name}"
          end
        end
      end
      graphs.push(graphs_1)
      graphs.push(graphs_2)
      graphs.push(graphs_3)
    end

    def match_rank(customer, worker)
      33
    end

    worker = flatten_user('worker')
    puts "Worker:"
    puts "#{worker.inspect}"

    customer = flatten_user('customer')
    puts "Customer:"
    puts "#{customer.inspect}"

    rank = match_rank(customer, worker)
    puts "Rank: #{rank}"

  end
end
