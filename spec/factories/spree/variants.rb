FactoryGirl.define do
  sequence :variants do |n|
    "user#{n}@example.com"
  end

  factory :spree_variant, :class => Spree::Variant do
    factory :dress_variant do
      price         { 198.37 }
      cost_price    { 177 }
      sku           { generate_sku }

      product       { |p| p.association(:dress) }
      option_values { [FactoryGirl.create(:option_value)] }
    end
  end
end
