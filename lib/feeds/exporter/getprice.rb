module Feeds
  module Exporter
    class Getprice < Base
      def export_file_name
        'getprice.tsv'
      end

      def export
        output = CSV.generate(col_sep: "\t") do |csv|
          csv << ['Product Name', 'MPN', 'SKU', 'Product ID', 'Short Description', 'Category Name', 'Brand', 'Model', 'Image Link', 'Product URL', 'Price', 'Shipment Costs', 'Size', 'Sale Price']
          @items.each do |item|
            csv << [item[:product].name, item[:variant_sku], item[:variant_sku], item[:product].id, @properties[item[:product].id].try(:[], :short_description), 'Dresses', 'Fame & Partners', item[:product].name, item[:image], "#{@config[:domain]}#{collection_product_path(item[:product])}", helpers.number_to_currency(item[:price]), 'Free delivery', item[:size], helpers.number_to_currency(item[:sale_price])]
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
