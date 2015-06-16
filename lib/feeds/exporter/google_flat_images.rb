require "net/http"

# fully inherits logic from google flat images
module Feeds
  module Exporter
    class GoogleFlatImages < Google
      CDN_HOST = "http://assets.fameandpartners.com/product-feed/"
      SUCCESS_CODE = "200"

      # @override
      def export_file_name
        'google-flat-images.xml'
      end

      private

      # @override
      #
      def get_image_link(item)
        cdn_url = URI.encode(CDN_HOST + "#{item.name}-#{item[:product].sku}-#{item[:color]}-#{"FRONT"}.jpg")

        url = URI.parse(cdn_url)
        req = Net::HTTP.new(url.host, url.port)
        res = req.request_head(url.path)

        if res.code == SUCCESS_CODE
          cdn_url
        else
          item[:image]
        end
      end
    end
  end
end
