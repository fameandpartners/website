FactoryGirl.define do
  factory :product_color_value, :class => ProductColorValue do

    trait :with_images do
      after(:create) do |instance|
        create_list(:spree_image, 3, viewable: instance)
      end
    end
  end
end
