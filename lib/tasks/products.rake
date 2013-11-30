namespace :products do
  desc 'Check that all products have sizes (4, 6) & if need correct it'
  task :check_and_correct_sizes => :environment do
    option_type_color = Spree::OptionType.find_by_name('dress-color')
    option_type_size = Spree::OptionType.find_by_name('dress-size')

    option_values_size = []

    option_values_size << option_type_size.option_values.where(name: '6').first_or_create(presentation: '6')
    option_values_size << option_type_size.option_values.where(name: '4').first_or_create(presentation: '4')

    Spree::Product.not_deleted.each do |product|
      option_values_color = Spree::OptionValue.
        where(option_type_id: option_type_color.id).
        joins(:variants).
        where(spree_variants: { product_id: product.id }).
        uniq

      option_value_combinations_ids = product.variants.map(&:option_value_ids)

      option_value_combinations = option_values_size.product(option_values_color)

      missing_option_value_combinations = option_value_combinations.select do |option_value_combination|
        ! option_value_combinations_ids.any? do |option_value_combination_ids|
          option_value_combination.all? do |option_value|
            option_value_combination_ids.include?(option_value.id)
          end
        end
      end

      missing_option_value_combinations.each do |option_values|
        option_values_description = option_values.map do |option_value|
          "#{option_value.option_type.presentation}: \"#{option_value.presentation}\""
        end.join(', ')

        puts "Product \"#{product.name}\", adding Variant with #{option_values_description}"

        variant = product.variants.build
        variant.on_demand = true
        variant.option_values = option_values
        variant.price = product.price
        variant.save
      end
    end
  end
end
