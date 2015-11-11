require 'rubygems'

#require ::File.expand_path('../../../config/environment', __FILE__)

namespace :profile do

  desc 'Flatten worker profile'

  task flatten: :environment do
    worker = User.find_by!(username: 'worker')
    puts "worker.profile: #{worker.profile.inspect}"
  end
end
