FactoryGirl.define do
  factory :local_committee do
    sequence(:recipient_id) {|n| "re_#{n}" }
    name_key "curitiba"
  end
end
