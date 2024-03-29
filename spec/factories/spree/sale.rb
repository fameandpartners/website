FactoryGirl.define do
  factory :sale, class: Spree::Sale do
    is_active true
    sitewide  true
    name      Faker::Lorem.word
    currency  ''
    discount_size 10
    discount_type Spree::Sale::DISCOUNT_TYPES.key('Percentage')
    sitewide_message Faker::Lorem.sentence

    trait(:for_product) do
      association(:discounts, factory: :discount)
    end
  end
end
