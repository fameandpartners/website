FactoryGirl.define do
  factory :line_item, class: Spree::LineItem do
    quantity 1
    price    100.0
    making_options []

    association(:order, factory: :spree_order)

    factory :dress_item do
      price { variant.price }

      association(:variant, factory: :dress_variant)
    end

    trait(:fast_making) do
      making_options { build_list :line_item_making_option, 1 }
    end

    trait(:with_personalization) do
      before(:create) do |item|
        item.personalization = FactoryGirl.create(:personalization, product: item.product, line_item: item, size: Spree::OptionValue.sizes.first)
      end
    end
  end
end
