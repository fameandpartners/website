module Feeds
  module Exporter
    class Getprice < Base
      def export
        output = CSV.generate(col_sep: "\t") do |csv|
          csv << ['Product Name', 'MPN', 'SKU', 'Product ID', 'Short Description', 'Category Name', 'Brand', 'Model', 'Image Link', 'Product URL', 'Price', 'Shipment Costs', 'Size']
          @items.each do |item|
            csv << [item[:title], item[:product].sku, item[:product].sku, item[:product].id, @properties[item[:product].id].try(:[], :short_description), 'Dresses', 'Fame & Partners', item[:product].name, item[:image], "http://#{@config[:domain]}#{collection_product_path(item[:product])}", item[:price], 'Free delivery', item[:size]]
          end
        end

        file_path = File.join(Rails.root, '/public/feeds/products/getprice.tsv')
        file = File.open(file_path, 'w')
        file.write(output.to_s)
        file.close
      end
    end
  end
end