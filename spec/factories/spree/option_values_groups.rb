FactoryGirl.modify do
  factory :option_values_group, class: Spree::OptionValuesGroup do
    name 'Red Color Group'
    presentation 'Red'
    available_as_taxon false
    option_type
  end
end
