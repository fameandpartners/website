module Feeds
  module Exporter
    class Base
      attr_accessor :items
      attr_accessor :config
      attr_accessor :properties
      attr_accessor :current_site_version

      attr_reader :logger
      def initialize(logger: )
        @logger = logger || Logger.new($stdout)
      end

      private

      def helpers
        @helpers ||= Feeds::Helpers.new
      end

      def export_file_path
        Rails.root.join(
          'public',
          current_site_version.permalink,
          'feeds',
          'products',
          export_file_name
        )
      end

      def current_currency
        current_site_version.currency
      end

      def image_link(item)
        raise NotImplementedError, "#{self.class} does not implement private method #image_link"
      end
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
        parts = ['dress', product.name.parameterize, product.id]
        parts.reject(&:blank?).join('-')
      end

      def url_without_double_slashes(url)
        url.gsub(/\w+(\/\/)/){ |a| a.sub('//', '/') }
      end
    end
  end
end
