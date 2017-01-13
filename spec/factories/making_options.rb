
FactoryGirl.define do
  factory :product_making_option, class: ProductMakingOption do
    price 10
    currency 'USD'
    option_type 'fast_making'
  end

  factory :line_item_making_option, class: LineItemMakingOption do |f|
    product_making_option do
      ProductMakingOption.where(option_type: 'fast_making').first || FactoryGirl.create(:product_making_option, option_type: 'fast_making')
    end
  end
end
