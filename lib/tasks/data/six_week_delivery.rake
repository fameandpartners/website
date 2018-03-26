namespace :data do
  desc 'Add 6 week delivery taxon'
  task :six_week_delivery => :environment do

  	taxon = Spree::Taxon.find_by_permalink('6-week-delivery') 
  	unless taxon
		taxon = Spree::Taxon.new

		taxon.delivery_period = '6 weeks'
		taxon.name = '6 week delivery'
		taxon.permalink = '6-week-delivery'
		taxon.save
	end

	products = Spree::Product.all

	products.each do |product|
		unless product.taxons.include?(taxon)
			product.taxons << taxon
		end
	end
  end
end