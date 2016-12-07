
FactoryGirl.define do
  factory :product_making_option, class: ProductMakingOption do
    price 10
    currency 'USD'
    option_type 'fast_making'
  end

  factory :line_item_making_option, class: LineItemMakingOption do
    association :product_making_option
  end
end
