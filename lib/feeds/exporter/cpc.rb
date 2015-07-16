module Feeds
  module Exporter
    class CPC < Base

      # @override
      def export_file_name
        'google.xml'
      end

      # @override
      def export
        xml = generate
        save(xml)
      end

      def generate
        xml = Builder::XmlMarkup.new

        xml.instruct! :xml, version: '1.0', encoding: 'UTF-8'

        xml.rss "version" => "2.0", "xmlns:g" => "http://base.google.com/ns/1.0" do
          xml.channel do
            xml.title @config[:title]
            xml.description @config[:description]

            xml.link @config[:domain]

            @items.each do |item|
              xml.item do
                xml.title item[:title]
                xml.link "#{@config[:domain]}#{helpers.collection_product_path(item[:product], color: item[:color].parameterize)}"
                xml.description product_description(item)

                # Event, Style and Lookbook
                xml.tag! "events"   , item[:events].join(',')
                xml.tag! "styles"   , item[:styles].join(',')
                xml.tag! "lookbooks", item[:lookbooks].join(',')

                xml.tag! "g:id", item[:id]
                xml.tag! "g:condition", "new"
                xml.tag! "g:price", helpers.number_to_currency(item[:price], format: '%n %u', unit: current_currency)
                xml.tag! "g:sale_price", helpers.number_to_currency(item[:sale_price], format: '%n %u', unit: current_currency)
                xml.tag! "g:availability", item[:availability]
                xml.tag! "g:image_link", image_link(item)
                xml.tag! "g:shipping_weight", item[:weight]

                xml.tag! "g:google_product_category", CGI.escapeHTML(item[:google_product_category])
                xml.tag! "g:product_type", item[:taxons].first
                xml.tag! "g:gender", "Female"
                xml.tag! "g:age_group", "Adult"
                xml.tag! "g:color", item[:color]
                xml.tag! "g:size", item[:size]

                xml.tag! "g:item_group_id", item[:group_id]

                # xml.tag! "g:gtin",
                xml.tag! "g:mpn", item[:variant_sku]

                xml.tag! "g:brand", "Fame&Partners"
                xml.tag! "g:additional_image_link", item[:images].join(',')
              end
            end
          end
        end
      end

      def save(xml)
        require 'fileutils'
        FileUtils::mkdir_p(File.dirname(export_file_path))

        file = File.open(export_file_path, 'w')
        file.write(xml)
        file.close
      end

      private

      # @override
      def image_link(item)
        item[:image]
      end

      # @override
      def product_description(item)
        CGI.escapeHTML(item[:description])
      end
    end
  end
end
