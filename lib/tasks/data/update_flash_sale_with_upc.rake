namespace :data do
	desc 'Update Flash Sale Items'
	task :update_flash_sale_with_upc => :environment do
		csv_path = 'inventory_sample.csv'

		CSV.foreach(csv_path) do |row|
			inventory_count = row[5].to_i
			inventory_count.times do

				li_color = Spree::OptionValue.find_by_name(row[2].downcase) # find color

				sku = row[8].downcase.gsub(" ","").gsub("/","")+"C#{li_color.id}"
				color_group =  li_color.option_values_groups.first.name
				variant = Spree::Variant.find_by_sku(sku)
				if variant.nil?
					sku = sku.upcase
					variant = Spree::Variant.find_by_sku(sku)
				end
				if variant.nil?
					variant = Spree::Variant.find_by_sku(sku.downcase)
				end
				if variant.nil?
					variant = Spree::Variant.find_by_sku(row[1].downcase)
				end
				if variant.nil?
					variant = Spree::Variant.find_by_sku(row[1].upcase)
				end

				#li.variant = variant				

				length = row[9]
				#li.length = length 

				#li.stock = true

				size = row[3].split('/').first

				new_price= ((((variant.product.price * 0.6)/ (10)).ceil*(10.00))-1).to_f
				height = row[7]

				li = Spree::LineItem.where("stock is not null AND size = '#{size}' AND length = '#{length}' AND variant_id = #{variant.id} AND  color = '#{color_group}' AND upc is null").first
				if li
					li.update_column('upc', row[0]) 
					li_size = Spree::OptionValue.find_by_name(size) # find size

					customizations = row[6]
					li_customization_values=[]
					customizations.split(';').each do |customization_name|
						unless customization_name == '0'
							li.personalization.customization_value_ids = []		
							cust_value = CustomisationValue.where(name: customization_name, product_id: li.variant.product_id).first
							if cust_value
								li.personalization.customization_value_ids << cust_value.id
							else
								li.personalization.customization_value_ids << CustomisationValue.where(name: customization_name).first.id
							end
							# map customizations
							li.personalization.save(validate: false)
						end
					end
					li.update_column('price', new_price) 
				end
				puts $.
			end
		end
	end
end