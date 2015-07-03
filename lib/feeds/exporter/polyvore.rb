require "net/http"

module Feeds
  module Exporter
    class Polyvore < CPC
      CDN_HOST = "http://assets.fameandpartners.com/product-feed/flat/"

      # @override
      def export_file_name
        'google-flat-images.xml'
      end

      private

      # @override
      def get_image_link(item)
        url = URI.encode(CDN_HOST + image_filename(item))

        if image_exists?(url)
          url
        else
          item[:image]
        end
      end

      def image_filename(item)
        [
          [
            item[:product_name],
            item[:product_sku],
            item[:color],
            'FRONT'
          ].join('-').parameterize.upcase,
          '.jpg'
        ].join('')
      end

      def image_exists?(url)
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
