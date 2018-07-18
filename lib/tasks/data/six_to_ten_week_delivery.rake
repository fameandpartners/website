namespace :data do
  desc 'Add 6-10 week delivery taxon'
  task :six_to_ten_week_delivery => :environment do

  	taxon = Spree::Taxon.find_by_permalink('6-10-week-delivery') 
  	unless taxon
			taxon = Spree::Taxon.new

			taxon.delivery_period = '6 - 10 weeks'
			taxon.name = '6 - 10 week delivery'
			taxon.permalink = '6-10-week-delivery'
			taxon.save!
		end
  end
end