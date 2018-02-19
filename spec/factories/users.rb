FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user-#{n}@example.com" }
    password "password123"
    password_confirmation "password123"
    local_committee
  end
end
