FactoryGirl.define do
  factory :line_item, class: Spree::LineItem do
    quantity 1
    price    100.0

    association(:order, factory: :spree_order)

    factory :dress_item do
      price    { variant.price }

      association(:variant, factory: :dress_variant)
    end
  end
end
