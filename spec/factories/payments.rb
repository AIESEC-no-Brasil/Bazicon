FactoryGirl.define do
  factory :payment do
    customer_name "John Doe"
    local_committee "Belo Horizonte"
    application_id "32"
    program "GV"
    opportunity_name "Living La Vida Loca"
    value 1500
  end
end
