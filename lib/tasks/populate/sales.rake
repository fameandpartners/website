namespace :db do
  namespace :populate do
    task :sales => :environment do
      sale = Spree::Sale.create do |sale|
        sale.name = 'Customizations for FREE! Exclude "Lace" customizations!'
        sale.discount_type = Spree::Sale::DISCOUNT_TYPES.index('Percentage')
        sale.discount_size = 100
        sale.is_active = false
      end

      CustomisationValue.all.each do |customization|
        if customization.presentation !~ /(^lace)|(.* lace)/i
          sale.discounts.create do |discount|
            discount.discountable = customization
          end
        end
      end
    end
  end
end
