namespace :quality do
  desc 'fix_variants_missing_prices'
  task :fix_variants_missing_prices => :environment do
    puts "Started"
    prods = Spree::Product.active.includes(:variants => [:prices])

    errors = []
    prods.each do |product|

      prices_attributes = product.master.prices.collect {|p| [p.currency, p.amount] }.uniq.to_h

      if product.variants.all? { |v| v.prices.count == 2 }
        puts "#{product.name} - OK"
        next
      end

      puts "#{product.name} - Setting Prices"

      unless product.master.prices.count == 2
        errors << "#{product.name} - MASTER has (#{product.master.prices.count}) PRICES"
      end

      unless prices_attributes.key? 'USD'
        prices_attributes['USD'] = prices_attributes['AUD']
        errors << "#{product.name} - Falling back to AUD for a USD for #{product.name}"
      end

      product.variants.each do |variant|
        next if variant.prices.count == 2
        next if variant.is_master

        puts variant.sku

        variant.prices.each do |p|
          puts " :: OLD PRICE: #{p.currency} #{p.amount}"
        end

        prices_attributes.each do |currency, amount|
          existing_price = variant.prices.detect { |p| p.currency == currency }

          next if existing_price
          puts " ++ CREATE PRICE: #{currency} #{amount}"
          variant.prices.create(currency: currency, amount: amount)

        end
      end
    end

    puts "Errors:"
    puts errors.join("\n")
    puts "Done"
  end
end
