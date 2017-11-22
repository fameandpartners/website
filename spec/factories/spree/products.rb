FactoryGirl.define do
  factory :dress, :aliases => [:spree_product], :class => Spree::Product do
    sequence(:name) { |n| "#{%w{Two-Piece Split Strapless Lace V-Neck Lace}.sample} #{n}" }
    sequence(:sku)  { |n| "sku-#{n}"}

    price         { rand(100) + 99 }
    featured      false
    available_on  { rand(100).days.ago.utc }
    permalink     { name.downcase.gsub(/\s/, '_') }
    customizations  "[{\"customisation_value\":{\"created_at\":\"2017-11-21T15:24:51.797-08:00\",\"customisation_type\":\"fabric\",\"id\":1,\"image_content_type\":null,\"image_file_name\":null,\"image_file_size\":null,\"name\":\"make-skirt-ankle-length-1\",\"point_of_view\":\"front\",\"position\":1,\"presentation\":\"Make Skirt Ankle Length 1\",\"price\":\"19.5\",\"product_id\":1,\"updated_at\":\"2017-11-21T15:24:51.797-08:00\"}},{\"customisation_value\":{\"created_at\":\"2017-11-21T15:24:51.803-08:00\",\"customisation_type\":\"cut\",\"id\":2,\"image_content_type\":null,\"image_file_name\":null,\"image_file_size\":null,\"name\":\"make-skirt-ankle-length-2\",\"point_of_view\":\"front\",\"position\":2,\"presentation\":\"Make Skirt Ankle Length 2\",\"price\":\"14.3\",\"product_id\":1,\"updated_at\":\"2017-11-21T15:24:51.803-08:00\"}}]"
    making_options { build(:product_making_option) }

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
