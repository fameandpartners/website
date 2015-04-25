FactoryGirl.define do

  factory :dress, :class => Spree::Product do
  
    sequence(:name) { |n| "#{%w{Two-Piece Split Strapless Lace V-Neck Lace}.sample} #{n}" }
    sequence(:sku)  { |n| "sku-#{n}"}

    price         { rand(100) + 99 } 
    featured      false
    available_on  { rand(100).days.ago.utc }
    permalink     { name.downcase.gsub(/\s/, '_') }

    # sequence(:position)   
    # after(:create) do |product, evaluator|
    #   create_list(:product_color_value, 1, product: product)
    # end
  end

  # factory :product_color_value do
  #   option_value
  # end

  # factory :option_value, :class => Spree::OptionValue do
  #   sequence(:position)
  #   sequence(:name)     { |n| "option-#{n}"}
  #   option_type         
  # end

  # factory :option_type :class => Spree::OptionType do
  #   sequence(:name)     { |n| "option-type-#{n}"}
  # end
end
