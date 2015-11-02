FactoryGirl.define do
  factory :dress, :aliases => [:spree_product], :class => Spree::Product do
    sequence(:name) { |n| "#{%w{Two-Piece Split Strapless Lace V-Neck Lace}.sample} #{n}" }
    sequence(:sku)  { |n| "sku-#{n}"}

    price         { rand(100) + 99 }
    featured      false
    available_on  { rand(100).days.ago.utc }
    permalink     { name.downcase.gsub(/\s/, '_') }

    factory :dress_with_variants do
      variants { create_list :dress_variant, 3 }
    end
  end
end
