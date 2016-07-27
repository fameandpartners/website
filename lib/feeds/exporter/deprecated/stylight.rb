require_relative '../../exporter/base'
require 'net/http'

module Feeds
  module Exporter
    class Stylight < Google
      CDN_HOST = 'https://d1h7wjzwtdym94.cloudfront.net/product-feed/white-background/'

      attr_reader :items

      # @override
      def export_file_name
        'stylight.xml'
      end

      # @override
      def generate
        delete_items_without_images

        super
      end

      private

      def delete_items_without_images
        items.reject! { |item| !image_exists?(item) }
      end

      # @override
      def image_link(item)
        URI.encode(CDN_HOST + image_filename(item))
      end

      def image_filename(item)
        [
            [
                item[:product_sku],
                item[:color],
                'FRONT'
            ].join('-').parameterize.upcase,
            '.jpg'
        ].join('')
      end

      def image_exists?(item)
        url = image_link(item)
        response_for(url) == '200'
      end

      def response_for(url)
        @responses ||= Hash.new do |h, url|
          uri = URI.parse(url)
          req = Net::HTTP.new(uri.host, uri.port)
          res = req.request_head(uri.path)

          h[url] = res.code
          logger.info "#{res.code} : #{url}"
        end
        @responses[url]
      end
    end
  end
end
