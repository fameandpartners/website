FactoryGirl.define do
  sequence(:color_value)  { "##{ Array.new(6){ rand(10) }.join}" }
  sequence(:dress_size)   {  rand(10) * 2 }

  factory :option_value, :class => Spree::OptionValue do
    name 'Size'
    presentation 'S'
    option_type

    trait 'dress-size' do
      value { generate(:dress_size) }
    end

    trait 'dress-color' do
      value { generate(:color_value) }
    end
  end
end
