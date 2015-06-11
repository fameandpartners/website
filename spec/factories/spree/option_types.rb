FactoryGirl.define do
  factory :option_type, :class => Spree::OptionType do
    name 'foo-size'
    presentation 'Size'

    trait :color do
      name 'dress-color'
    end
  end
end