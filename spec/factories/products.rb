FactoryGirl.define do
  factory :dress, :class => Spree::Product do
  
    sequence(:name) { |n| "#{%w{Two-Piece Split Strapless Lace V-Neck}.sample} #{n}" }
    sequence(:sku)  { |n| "sku-#{n}"}

    price         { rand(100) + 99 } 
    featured      false
    available_on  { Time.now.utc }
    permalink     { name.downcase.gsub(/\s/, '_') }

  end
end
