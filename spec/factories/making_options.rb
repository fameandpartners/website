
FactoryGirl.define do
  factory :making_option, class: MakingOption do
    flat_price_usd 10
    flat_price_aud 15
  end

  factory :product_making_option, class: ProductMakingOption do
    making_option
  end

  factory :line_item_making_option, class: LineItemMakingOption do |f|
    product_making_option
  end
end
