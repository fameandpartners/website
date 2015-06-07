# fully inherits logic from google flat images
module Feeds
  module Exporter
    class GoogleFlatImages < Google
      CDN_HOST = "http://assets.fameandpartners.com/product-feed/"

      # @override
      def export_file_name
        'google-flat-images.xml'
      end

      private

      # @override
      def get_image_link(item)
        CDN_HOST + "flat-#{item[:product].sku}-#{item[:color]}.jpg"
      end
    end
  end
end
