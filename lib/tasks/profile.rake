require 'rubygems'

#require ::File.expand_path('../../../config/environment', __FILE__)

namespace :profile do

  desc 'Flatten worker profile'

  task flatten: :environment do
    graphs = []
    worker = User.find_by!(username: 'worker')
    profile = worker.profile
    #puts "Profile: #{profile.inspect}"
    profile.children.each do |category|
      category_name = Category.find(category.this_id).name
      graphs.push([category_name])
      #puts "#{category_name}"
      category.children.each do |skill|
        skill_name = Skill.find(skill.this_id).name
        graphs.push([category_name, skill_name])
        #puts "-#{skill_name}"
        skill.children.each do |tag|
          tag_name = Tag.find(tag.this_id).name
          graphs.push([category_name, skill_name, tag_name])
          #puts "--#{tag_name}"
        end
      end
    end
    puts graphs.inspect
  end
end
