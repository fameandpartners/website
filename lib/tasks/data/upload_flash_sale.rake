namespace :data do
  desc 'Upload Flash Sale Items'
  task :upload_flash_sale => :environment do
  	order = Spree::Order.new
	order.save # 39149267

	sql1 = ""
	sql2 = ""
	csv_path = 'inventory_sample.csv'
	line_item_insert_statements = []
	lip_insert_statements = []	
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

			length = row[9]

			size = row[3]

			new_price= (((variant.product.price * 0.6).to_i * (-10)).ceil.to_f/(-10.00) - 1).to_f
			height = row[7]

			line_item_insert_statements<<"(#{order.id},#{variant.id},#{variant.product.price},#{new_price},'#{size}',#{1},#{true},'#{length}', '#{color_group}','#{Time.now}','#{Time.now}')"

		end
		puts $.
	end
	sql1 = "INSERT INTO spree_line_items (order_id,variant_id,old_price,price,size,quantity,stock,length,color,created_at,updated_at)VALUES #{line_item_insert_statements.join(", ")} RETURNING id"

	line_item_ids=ActiveRecord::Base.connection.execute(sql1).map{ |x| x["id"]}

	counter = 0

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

			size = row[3]

			new_price= (((variant.product.price * 0.6).to_i * (-10)).ceil.to_f/(-10.00) - 1).to_f
			height = row[7]

			li_size = Spree::OptionValue.find_by_name(size) # find size

			customizations = row[6]
			li_customization_values=[]
			customizations.split(';').each do |customization_name|
				unless customization_name == '0'
					li_customization_values << CustomisationValue.find_by_name('change-dress-to-midi-length')# map customizations
				end
			end
			puts $.
			customization_ids = li_customization_values.map {|cv| cv.id}.empty? ? '---' :  "---\n- #{li_customization_values.map {|cv| cv.id}.join('\n- ')}"
			lip_insert_statements<<"(#{variant.product.id},#{li_size.id},#{line_item_ids[counter]},'#{customization_ids}','#{li_color.id}','#{height}','#{Time.now}','#{Time.now}')"
			counter = counter + 1

		end
	end

	sql2 = "INSERT INTO line_item_personalizations (product_id,size_id,line_item_id,customization_value_ids,color_id,height,created_at,updated_at)VALUES #{lip_insert_statements.join(", ")}"

	ActiveRecord::Base.connection.execute(sql2)
	end

end
