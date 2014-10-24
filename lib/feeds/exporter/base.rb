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
        @helpers ||= Feeds::Helpers.new(current_site_version)
      end

      def collection_product_path(product)
        helpers.collection_product_path(product)
      end
      #
      # def descriptive_url(product)
      #   parts = []
      #   parts << product.translated_short_description(I18n.locale).parameterize
      #   parts << product.name.parameterize
      #   parts << product.id
      #
      #   parts.reject(&:blank?).join('-')
      # end
      #
      # def url_without_double_slashes(url)
      #   # search elements with not colons and replace inside them
      #   url.gsub(/\w+(\/\/)/){|a| a.sub('//', '/')}
      # end
    end
  end
end