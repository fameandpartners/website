FactoryGirl.define do
  factory :option_type, :class => Spree::OptionType do
    name 'foo-size'
    presentation 'Size'

    initialize_with { Spree::OptionType.find_or_create_by_name(name) }

    trait :color do
      name 'dress-color'
      presentation 'Color'
    end

    trait :size do
      name 'dress-size'
    end
  end
end
