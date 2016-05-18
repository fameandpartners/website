FactoryGirl.define do
  factory :return_request_item do
    order_return_request
    line_item

    trait :return do
      action 'return'
    end
  end
end
