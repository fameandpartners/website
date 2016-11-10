FactoryGirl.define do
  factory :return_request_item do
    order_return_request
    line_item

    trait :return do
      action 'return'
      reason_category 'Size and fit'
      reason 'Dress was too big around the bust'
    end

    trait :keep do
      action 'keep'
    end
  end
end
