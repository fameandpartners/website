FactoryGirl.define do
  factory :dress, :aliases => [:spree_product], :class => Spree::Product do
    sequence(:name) { |n| "#{%w{Two-Piece Split Strapless Lace V-Neck Lace}.sample} #{n}" }
    sequence(:sku)  { |n| "sku-#{n}"}

    price         { rand(100) + 99 }
    featured      false
    available_on  { rand(100).days.ago.utc }
    permalink     { name.downcase.gsub(/\s/, '_') }


    # ensure 
    trait :with_size_color_variants do
      option_types {
        [ Spree::OptionType.color, Spree::OptionType.size ]
      }

      after(:create) do |instance|
        Spree::OptionType.color.option_values.each do |color|
          create(:product_color_value, :with_images, product_id: instance.id, option_value_id: color.id)

          Spree::OptionType.size.option_values.each do |size|
            create(:spree_variant, product: instance, option_values: [color, size])
          end
        end
      end
    end
  end
end
