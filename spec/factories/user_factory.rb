# Create a list of users with email 'usern@example.com' and password 'password'
FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password "password"

    trait :admin do
      admin true
    end
  end
end