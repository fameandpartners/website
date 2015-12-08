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
        event  = perfect_for_event(item)

        [brand, title, event, styles, size].compact.join(' ')
      end

      private def perfect_for_event(item)
        unless item[:events].blank?
          event = item[:events].first.titleize
          "- Perfect for #{event}"
        end
      end

      private def in_size(item)
        unless item[:size].blank?
          "in Size #{item[:size]}"
        end
      end

      private def available_in_styles(item)
        unless item[:styles].blank?
          styles = item[:styles].join(', ')
          "Available in #{styles}"
        end
      end

      private def brand
        'Frame & Partners'.freeze
      end
    end
  end
end
