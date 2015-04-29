FactoryGirl.define do
  factory :line_item, class: Spree::LineItem do
    quantity 1
    price    100.0
  end
end
