FactoryGirl.define do
  factory :personalization, class: LineItemPersonalization do
    association :color, factory: :product_colour
    association :size, factory: :product_size
  end
end
