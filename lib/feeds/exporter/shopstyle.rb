module Feeds
  module Exporter
    class Shopstyle < CPC
      # @override
      def export_file_name
        'shopstyle.xml'
      end

      # @override
      private def title(item)
        title  = item[:title]
        styles = available_in_styles(item)
        size   = in_size(item)
        events = perfect_for_event(item)

        [brand, title, events, styles, size].compact.join(' ')
      end

      private def perfect_for_event(item)
        unless item[:events].blank?
          events = item[:events].map(&:titleize).join(', ')
          "- Perfect for #{events}"
        end
      end

      private def in_size(item)
        unless item[:size].blank?
          "in Size #{item[:size]}"
        end
      end

      private def available_in_styles(item)
        unless item[:styles].blank?
          styles = item[:styles].map(&:titleize).join(', ')
          "Available in #{styles}"
        end
      end

      private def brand
        'Fame & Partners'.freeze
      end
    end
  end
end
