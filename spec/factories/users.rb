FactoryGirl.define do
  factory :user do
    email "johndoe@example.com"
    password "password123"
    password_confirmation "password123"
    local_committee "curitiba"
  end
end
