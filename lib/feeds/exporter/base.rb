module Feeds
  module Exporter
    class Base
      attr_accessor :items
      attr_accessor :config
      attr_accessor :properties
      attr_accessor :current_site_version

      private

      def export_file_path
        path_parts = []
        path_parts << Rails.root
        path_parts << '/public/'
        path_parts << current_site_version.permalink
        path_parts << '/feeds/products/'
        path_parts << export_file_name
        File.join(path_parts)
      end

      def current_currency
        current_site_version.currency
      end

      def current_site_version
        @current_site_version
      end

      def helpers
        @helpers ||= Feeds::Helpers.new
      end

      def collection_product_path(product)
        helpers.collection_product_path(product)
      end
    end
  end
end