FactoryGirl.define do
  factory :product_color_value do
    association :product, factory: :dress
  end
end
