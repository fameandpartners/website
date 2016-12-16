FactoryGirl.define do
  factory :line_item, class: Spree::LineItem do
    quantity 1
    price    100.0

    association(:order, factory: :spree_order)

    factory :dress_item do
      price { variant.price }

      association(:variant, factory: :dress_variant)
    end

    trait(:fast_making) do
      making_options { build_list :line_item_making_option, 1 }
    end
  end
end
