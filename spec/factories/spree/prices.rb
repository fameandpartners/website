require 'spree/core/testing_support/factories/price_factory'

FactoryGirl.modify do
  factory :price, class: Spree::Price do
    association :variant, factory: :spree_variant
    currency 'AUD'
  end
end
