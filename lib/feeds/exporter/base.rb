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

      def helpers
        @helpers ||= Feeds::Helpers.new
      end

      def collection_product_path(product, options = {})
        path_parts = ['dresses']
        if product.respond_to?(:descriptive_url)
          path_parts << product.descriptive_url
        else
          path_parts << descriptive_url(product)
        end

        if options[:color].nil? && product.respond_to?(:color) && product.color.try(:name)
          options.merge!({ color: product.color.name })
        end

        path =  '/' + path_parts.compact.join('/')
        path = "#{path}?#{options.to_param}" if options.present?

        url_without_double_slashes(path)
      end

      def descriptive_url(product)
        parts = []
        parts << "dress"
        parts << product.name.parameterize
        parts << product.id

        parts.reject(&:blank?).join('-')
      end

      def url_without_double_slashes(url)
        # search elements with not colons and replace inside them
        url.gsub(/\w+(\/\/)/){|a| a.sub('//', '/')}
      end
    end
  end
end
