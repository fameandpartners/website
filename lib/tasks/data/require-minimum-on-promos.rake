namespace :data do
    task :require_minimum_all_promos => :environment do
		Spree::Promotion.all.each do |promo|
			rule = Spree::Promotion::Rules::ItemTotal.new
			rule.activator_id = promo.id
			rule.save
		end
	end
end