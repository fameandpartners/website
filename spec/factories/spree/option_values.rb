FactoryGirl.define do
  factory :option_value, :class => Spree::OptionValue do
    name 'Size'
    presentation 'S'
    option_type
  end
end