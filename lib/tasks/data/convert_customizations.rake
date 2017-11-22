namespace :data do
  desc 'Migrate product customizations to json column'
  task :convert_customizations_to_json => :environment do
    counter = 0
    Spree::Product.find_each do |product|
      if product.customisation_values
        product.customizations = product.customisation_values.to_json
        product.save
        counter += 1
      end
    end
    puts "Rows update: #{counter}"
  end
end