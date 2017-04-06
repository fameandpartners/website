FactoryGirl.define do
  factory :option_values_group, class: Spree::OptionValuesGroup do
    name 'Red'
    presentation { name.capitalize }
    available_as_taxon false
    option_type

    trait :with_option_value do
      after(:create) do |instance|
        create_list(:product_colour, 1, name: instance.name)
      end
    end
  end
end
