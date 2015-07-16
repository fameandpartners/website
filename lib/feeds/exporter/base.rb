module Feeds
  module Exporter
    class Base
      attr_accessor :items
      attr_accessor :config
      attr_accessor :properties
      attr_accessor :current_site_version

      attr_reader :logger
      def initialize(logger: nil)
        @logger = logger || Logger.new($stdout)
      end

      def export
        raise NotImplementedError, "#{self.class} does not implement public method #export"
      end

      def export_file_name
        raise NotImplementedError, "#{self.class} does not implement public method #export_file_name"
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

      def product_description(item)
        raise NotImplementedError, "#{self.class} does not implement private method #product_description"
      end
    end
  end
end
