FactoryGirl.define do
  factory :option_value, :class => Spree::OptionValue do
    name 'Size'
    presentation 'S'
    option_type

    factory :product_size do
      ignore do
        size_template { (0..26).step(2).to_a.sample }
      end

      # name         { "US#{size_template}/AU#{size_template + 4}" }
      # presentation { "US #{size_template}/AU #{size_template + 4}" }

      name         { size_template }
      presentation { size_template }

      option_type { create :option_type, :size }
    end
  end
end
