FactoryGirl.define do
  factory :order_return_request do
    association :order, factory: :spree_order
  end
end
