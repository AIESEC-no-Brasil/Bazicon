FactoryGirl.define do
  factory :user do
    email "johndoe@example.com"
    password "password123"
    password_confirmation "password123"
  end
end
