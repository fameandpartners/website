module OrderBot
	class Product
		include Spree::OrderBotHelper

		def initialize(line_item, product)
			group_ids = get_or_create_group_id_by_product(product)
			product_images_string = generate_html_encoded_images(product)
			@reference_product_id = product.id # This is going to need to change
			@component_group_id = group_ids[1]
			@group_id = group_ids[0]
			@upc = GlobalSku.find_by_product_id(product.id).upc
      @description = "#{product.name},  UPC: #{@upc} %lt;br%gt; #{product_images_string}"
      @create_bom = false
      @create_purchase_unit = false
      @name = line_item.style_name
      @sku = CustomItemSku.new(line_item).call
      @base_price = line_item.price.to_f
      @units_of_measure = 1
      @units_of_measure_type_id = get_measurement_type_id_by_name('Each')
      @weight = 3.0
      @shipping_units_of_measure_type_id = 1
      @taxable = true #Assume everything is taxable it is dependent on where the order is from
      @min_quantity = 1
      @active = true
      @is_parent = false
			@country_of_product = 'CN'
			@create_bom = true
			@bom_quantity = 1
			@hts = get_product_hts(product)
		end

		private

		def generate_html_encoded_images(product)
			image_string = ""
			product.images.each { |image| image_string += "%lt;img src=\"#{image.attachment.url}\" width=\"300\" %gt; "}
			image_string
		end

		def get_product_hts(product)
			main = product.product_properties.select{|x| x.property.name == 'fabric'}.first&.value&.split("\n")&.first

			if main.nil?
				return
			end
			if main.downcase.include?("polyester")
				return '6204.43.4030'
			elsif main.downcase.include?("cotton")
				if main.downcase.include?("100%")
					return '6211.42.1081'
				else
					return '6204.42.3050'
				end
			else
				return nil
			end
		end

	end
end
