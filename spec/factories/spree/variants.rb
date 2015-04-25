FactoryGirl.define do
  sequence :variants do |n|
    "user#{n}@example.com"
  end

  factory :spree_variant, :class => Spree::Variant do
  end
end
