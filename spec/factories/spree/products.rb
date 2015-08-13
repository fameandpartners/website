FactoryGirl.define do
  # In the meanwhile, a jacket will be the same as dress
  factory :dress, :aliases => [:spree_product, :jacket], :class => Spree::Product do
    sequence(:name) { |n| "#{%w{Two-Piece Split Strapless Lace V-Neck Lace}.sample} #{n}" }
    sequence(:sku)  { |n| "sku-#{n}"}

    price         { rand(100) + 99 } 
    featured      false
    available_on  { rand(100).days.ago.utc }
    permalink     { name.downcase.gsub(/\s/, '_') }
  end
end
