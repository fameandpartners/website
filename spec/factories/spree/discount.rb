FactoryGirl.define do
  factory :discount, class: Discount do
    amount 10
    discountable_type 'Spree::Product'
  end
end
