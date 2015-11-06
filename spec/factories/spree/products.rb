FactoryGirl.define do
  factory :dress, :aliases => [:spree_product], :class => Spree::Product do
    sequence(:name) { |n| "#{%w{Two-Piece Split Strapless Lace V-Neck Lace}.sample} #{n}" }
    sequence(:sku)  { |n| "sku-#{n}"}

    price         { rand(100) + 99 }
    featured      false
    available_on  { rand(100).days.ago.utc }
    permalink     { name.downcase.gsub(/\s/, '_') }

    factory :dress_with_variants do |f|
      after(:create) do |dress, _evaluator|
        3.times do
          dress.variants << create(:dress_variant, product: dress)
        end
      end
    end

    factory :dress_with_magenta_size_10 do |f|
      after(:create) do |dress, _evaluator|

        magenta = create(:product_colour, name: 'magenta', presentation: 'Magenta')
        ten     = create(:product_size, size_template: 10)


        dress.variants << create(:dress_variant, product: dress, option_values: [magenta, ten] )
      end
    end
  end
end
