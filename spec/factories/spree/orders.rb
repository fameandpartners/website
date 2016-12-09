FactoryGirl.define do
  factory :spree_order, class: Spree::Order do
    association(:shipping_address, factory: :address)

    factory :complete_order do
      completed_at { DateTime.now }
    end

    factory :complete_order_with_items do
      association(:user,         factory: :spree_user)
      association(:bill_address, factory: :address)

      completed_at { DateTime.now }
      state        'complete'

      line_items   { build_list :dress_item, 1 }
    end
  end
end
