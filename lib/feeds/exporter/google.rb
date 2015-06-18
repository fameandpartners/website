module Feeds
  module Exporter
    class Google < Base
      def export_file_name
        'google.xml'
      end

      def export
        output = ''
        xml = Builder::XmlMarkup.new(target: output)

        xml.instruct! :xml, version: '1.0', encoding: 'UTF-8'

        xml.rss "version" => "2.0", "xmlns:g" => "http://base.google.com/ns/1.0" do
          xml.channel do
            xml.title @config[:title]
            xml.description @config[:description]

            production_domain = @config[:domain]
            xml.link production_domain

            @items.each do |item|
              xml.item do
                xml.title item[:title]
                xml.link "http://#{production_domain}#{collection_product_path(item[:product], color: item[:color].parameterize)}"
                xml.description CGI.escapeHTML(item[:description])

                xml.tag! "g:id", item[:id]
                xml.tag! "g:condition", "new"
                xml.tag! "g:price", helpers.number_to_currency(item[:price], format: '%n %u', unit: current_currency)
                xml.tag! "g:sale_price", helpers.number_to_currency(item[:sale_price], format: '%n %u', unit: current_currency)
                xml.tag! "g:availability", item[:availability]
                xml.tag! "g:image_link", item[:image]
                xml.tag! "g:shipping_weight", item[:weight]

                xml.tag! "g:google_product_category", CGI.escapeHTML(item[:google_product_category])
                item[:google_product_types].each do |product_type|
                  xml.tag! "g:product_type", CGI.escapeHTML(product_type)
                end
                xml.tag! "g:gender", "Female"
                xml.tag! "g:age_group", "Adult"
                xml.tag! "g:color", item[:color]
                xml.tag! "g:size", item[:size]

                xml.tag! "g:item_group_id", item[:group_id]

                # xml.tag! "g:gtin",
                xml.tag! "g:mpn", item[:variant_sku]

                xml.tag! "g:brand", "Fame&Partners"
                xml.tag! "g:product_type"
                item[:images].to(9).each do |image|
                  xml.tag! "g:additional_image_link", image
                end
              end
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
