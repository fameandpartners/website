require_relative './base'
require 'fog'

module Feeds
  module Exporter
    class Google < Base

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
                xml.title title(item)
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
        Fog::Storage.new(storage_credentials).
          directories.
          get(ENV['AWS_S3_BUCKET']).
          files.
          create(
            key:    export_file_path,
            body:   xml,
            public: true
          )
      end

      private

      # @override
      def title(item)
        item[:title]
      end

      # @override
      def image_link(item)
        item[:image]
      end

      # @override
      def product_description(item)
        CGI.escapeHTML(item[:description])
      end

      def storage_credentials
        storage_credentials = {
          provider:        'AWS',
          region:          ENV['AWS_S3_REGION'],
          use_iam_profile: true
        }

        storage_credentials.tap do |credentials|
          credentials.merge!({
                               aws_access_key_id:     ENV['AWS_S3_ACCESS_KEY_ID'],
                               aws_secret_access_key: ENV['AWS_S3_SECRET_ACCESS_KEY'],
                               use_iam_profile:       false
                             }) if Rails.env.development?
        end
      end
    end
  end
end
