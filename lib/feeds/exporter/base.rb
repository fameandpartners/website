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

      %w(export export_file_name).each do |method_name|
        define_method(method_name) do
          raise NotImplementedError, "#{self.class} does not implement public method ##{method_name}"
        end
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

      %w(title image_link product_description).each do |method_name|
        define_method(method_name) do |argument|
          raise NotImplementedError, "#{self.class} does not implement private method ##{method_name}"
        end
      end
    end
  end
end
