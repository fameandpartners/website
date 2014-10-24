module Feeds
  module Exporter
    class Myshopping < Base
      def export
        output = ''
        xml = Builder::XmlMarkup.new(target: output)

        xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8"
        xml.productset do
          @items.each do |item|
            xml.product do
              xml.tag! 'Code', item[:product].sku
              xml.tag! 'Category', { 'xml:space' => 'preserve' }, 'Clothing'
              xml.tag! 'Name', item[:title]
              xml.tag! 'Description', helpers.strip_tags(item[:description])
              xml.tag! 'Product_URL', "http://#{@config[:domain]}#{collection_product_path(item[:product])}"
              xml.tag! 'Price', item[:price]
              xml.tag! 'Image_URL', item[:image]
              xml.tag! 'Brand', 'Fame & Partners'
              xml.tag! 'InStock', 'Y'
            end
          end
        end

        file_path = File.join(Rails.root, '/public/feeds/products/myshopping.xml')
        file = File.open(file_path, 'w')
        file.write(output.to_s)
        file.close
      end
    end
  end
end