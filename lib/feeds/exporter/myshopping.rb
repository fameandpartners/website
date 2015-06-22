module Feeds
  module Exporter
    class Myshopping < Base
      def export_file_name
        'myshopping.xml'
      end

      def export
        output = ''
        xml = Builder::XmlMarkup.new(target: output)

        xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8"
        xml.productset do
          @items.each do |item|
            xml.product do
              xml.tag! 'Code', item[:variant_sku]
              xml.tag! 'Category', { 'xml:space' => 'preserve' }, 'Clothing'
              xml.tag! 'Name', item[:product].name
              xml.tag! 'Description', helpers.strip_tags(item[:description])
              xml.tag! 'Product_URL', "#{@config[:domain]}#{collection_product_path(item[:product])}"
              xml.tag! 'Price', helpers.number_to_currency(item[:price], unit: '')
              xml.tag! 'Image_URL', item[:image]
              xml.tag! 'Brand', 'Fame & Partners'
              xml.tag! 'InStock', 'Y'
            end
          end
        end

        require 'fileutils'
        FileUtils::mkdir_p(File.dirname(export_file_path))

        file = File.open(export_file_path, 'w')
        file.write(output.to_s)
        file.close
      end
    end
  end
end
