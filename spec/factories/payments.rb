FactoryGirl.define do
  factory :payment do
    customer_name "John Doe"
    customer_email "johndoe@gmail.com"
    local_committee
    application_id "32"
    program "gv"
    opportunity_name "Living La Vida Loca"
    value 1500
    status "waiting_payment"
  end
end
