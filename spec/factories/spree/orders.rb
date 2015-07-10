FactoryGirl.define do
  factory :spree_order, class: Spree::Order do
    factory :complete_order do
      completed_at { DateTime.now }
    end
  end
end
