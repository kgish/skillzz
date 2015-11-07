require "faker"

# Create a list of users with email 'usern@example.com' and password 'password'
FactoryGirl.define do
  factory :user do
    username { Faker::Internet.user_name }
    email { Faker::Internet.email }
    password "password"

    trait :admin do
      admin true
    end
  end
end