FactoryGirl.define do
  factory :payment do
    user_id 1
    valid false
    response "MyText"
    amount 1
  end
end
