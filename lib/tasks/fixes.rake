namespace :fixes do
  desc 'Fix "on_demand" field for existing products which have any available variant'
  task :masters_on_demand => :environment do
    Spree::Product.all.each do |product|
      if product.variants.any?(&:on_demand?)
        product.master.update_column(:on_demand, true)
      end
    end
  end
end
