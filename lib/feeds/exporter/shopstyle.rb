require_relative './google'

module Feeds
  module Exporter
    class Shopstyle < Google
      # @override
      def export_file_name
        'shopstyle.xml'
      end

      private

      # Sample result: Fame & Partners Vintage Queen Cherry Red Lace Dress Evening Dresses

      # @override
      def title(item)
        title  = item[:product_name]
        styles = available_in_styles(item)
        events = event_names(item)

        [brand, styles, events, title, 'Dress'].join(' ')
      end

      def available_in_styles(item)
        Array.
          wrap(item[:styles]).
          first(2).
          map(&:titleize).
          join(' ')
      end

      def event_names(item)
        Array.
          wrap(item[:events]).
          first(2).
          map(&:titleize).
          join(' ')
      end

      def brand
        'Fame & Partners'.freeze
      end
    end
  end
end
