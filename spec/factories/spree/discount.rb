FactoryGirl.define do
  factory :discount, class: Discount do
    amount 10
    discountable_type 'Spree::Product'
    discountable { create(:spree_product) }
  end
end
