module Feeds
  module Exporter
    class Base
      attr_accessor :items
      attr_accessor :config
      attr_accessor :properties
      attr_accessor :current_site_version

      private

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
        site_version_prefix = current_site_version.permalink
        path_parts = [site_version_prefix, 'dresses', 'p']
        if product.respond_to?(:descriptive_url)
          path_parts << product.descriptive_url
        else
          path_parts << descriptive_url(product)
        end
        path =  "/" + path_parts.compact.join('/')

        url_without_double_slashes(path)
      end

      def descriptive_url(product)
        parts = []
        parts << product.translated_short_description(I18n.locale).parameterize
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