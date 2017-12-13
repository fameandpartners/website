namespace :data do
  desc 'update items to usd price'
  task :update_flash_sale_items_USD => :environment do
  		items = Spree::LineItem.where('stock is not null')

  		items.each do |item|
			old_price = item.variant.price_in('USD').amount

			new_price= ((((old_price * 0.6)/ (10)).ceil*(10.00))-1).to_f
			item.update_column('old_price', old_price) 
			item.update_column('price', new_price) 

  		end

			
	end

end
