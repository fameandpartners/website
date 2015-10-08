require "net/http"

module Feeds
  module Exporter
    class Polyvore < CPC
      # @override
      def export_file_name
        'google-flat-images.xml'
      end

      private

      # @override
      def title(item)
        styles       = item[:styles].first(2).join(' ').titleize
        product_name = item[:title]

        [styles, product_name].reject(&:blank?).join(' ')
      end

      # @override
      def product_description(item)
        events = item[:events].map { |e| e.titleize.pluralize }.join(', ')
        styles = item[:styles].join(', ')

        product_description = fabric_description(item)
        product_description += ". Perfect for these events: #{events}" unless events.blank?
        product_description += ". Styles: #{styles}" unless styles.blank?
      end

      def fabric_description(item)
        whats_made_of = item[:fabric].to_s

        # Separate words
        whats_made_of.gsub! /([a-z]+)([A-Z][a-z]+)/, "\\1\n\\2"

        # Replace paragraph tags with line breaks
        whats_made_of.gsub! /<p>/, "\n"

        whats_made_of.split("\n").map(&:strip).join(', ')
      end
    end
  end
end
