FactoryGirl.define do

  factory :dress, :class => Spree::Product do
  
    sequence(:name) { |n| "#{%w{Two-Piece Split Strapless Lace V-Neck}.sample} #{n}" }
    sequence(:sku)  { |n| "sku-#{n}"}

    price         { rand(100) + 99 } 
    featured      false
    available_on  { Time.now.utc }
    permalink     { name.downcase.gsub(/\s/, '_') }
   
    after(:create) do |product, evaluator|
      create_list(:product_color_value, 1, product: product)
    end

  end

  factory :product_color_value do
    association :option_value, :factory => :spree_option_value
  end

  factory :spree_option_value, :class => Spree::OptionValue do
    sequence(:position)
    sequence(:name)     { |n| "option-#{n}"}
  end

end
