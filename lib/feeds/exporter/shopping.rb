module Feeds
  module Exporter
    class Shopping < Base
      def export_file_name
        'shopping.xml'
      end

      def export
        output = ''
        xml = Builder::XmlMarkup.new(target: output)

        xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8"
        xml.Products do
          @items.each do |item|
            xml.Product do
              xml.tag! 'Merchant_SKU', item[:variant_sku]
              xml.tag! 'Product_Name', item[:product].name
              xml.tag! 'Product_URL', "#{@config[:domain]}#{collection_product_path(item[:product])}"
              xml.tag! 'Image_URL', item[:image]
              xml.tag! 'Current_Price', helpers.number_to_currency(item[:sale_price])
              xml.tag! 'Shipping_Rate', 'Free Shipping'
              xml.tag! 'Stock_Availability', 'In-stock'
              xml.tag! 'Condition', 'New'
              xml.tag! 'Original_Price', helpers.number_to_currency(item[:price])
              xml.tag! 'Coupon_Code', 'Shopper20'
              xml.tag! 'Coupon_Code_Description', 'Get $20 off'
              xml.tag! 'Manufacturer', 'Fame & Partners'
              xml.tag! 'Product_Description', helpers.strip_tags(item[:description])
              xml.tag! 'Product_Type', 'Dress'
              xml.tag! 'Category', 'Clothing & Accessories > clothing > Dress'
              xml.tag! 'Category_ID', 31515
              xml.tag! 'Estimated_Ship_Date', '10 Working Days Delivery'
              xml.tag! 'Gender','Women, Girls'
              xml.tag! 'Color', item[:color]
              xml.tag! 'Material', @properties[item[:product].id].try(:[], :fabric)
              xml.tag! 'Size', item[:size]
              item[:images].each_with_index do |image, index|
                xml.tag! "Alternative_Image_URL_#{index + 1}", image
              end
            end
          end
        end

        file = File.open(export_file_path, 'w')
        file.write(output.to_s)
        file.close
      end
    end
  end
end
