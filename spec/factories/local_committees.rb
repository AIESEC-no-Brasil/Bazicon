FactoryGirl.define do
  factory :local_committee do
    sequence(:recipient_id) {|n| n }
    name_key "curitiba"
  end
end
