source 'https://rubygems.org'

ruby '2.2.2'

gem 'rails', '4.2.3'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'jquery-rails'
gem 'bootstrap-sass', '~> 3.3'
gem 'font-awesome-rails', '~> 4.3'
gem 'simple_form', '~> 3.1.0'
gem 'devise', '~> 3.4.1'
gem 'pundit', '~> 0.3.0'
gem 'awesome_nested_set'

# Nice gems for pagination
gem 'will_paginate', '~> 3.0.6'
gem 'will_paginate-bootstrap'

# Not for production, specific for book Rails 4 in Action
gem 'searcher', github: 'radar/searcher'

# Generate fake data such as names, addresses, and phone numbers.
gem 'faker', github: 'stympy/faker'

group :development, :test do

  # See https://github.com/rweng/pry-rails, use 'binding.pry'
  gem 'pry-rails'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  gem 'rspec-rails', '~> 3.2.1'
  gem 'mysql2', '~> 0.3.20'
end

group :test do
  gem 'capybara', '~> 2.4'
  gem 'factory_girl_rails', '~> 4.5'
  gem 'selenium-webdriver', '~> 2.45'
  gem 'database_cleaner', '~> 1.4'
end

group :production do
  gem 'pg'
  gem 'rails_12factor'
  gem 'puma'
end

