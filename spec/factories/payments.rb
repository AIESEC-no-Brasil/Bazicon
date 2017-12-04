FactoryGirl.define do
  factory :payment do
    customer_name "John Doe"
    local_committee "curitiba"
    application_id "32"
    program "gv"
    opportunity_name "Living La Vida Loca"
    value 1500
    status "pending"
  end
end
