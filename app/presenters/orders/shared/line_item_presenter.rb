require 'forwardable'

module Orders
  module Shared
    class LineItemPresenter

      attr_reader :item, :wrapped_order
      alias_method :order, :wrapped_order

      extend Forwardable
      def_delegators :@item,
                     :variant,
                     :personalization

      def initialize(item, wrapped_order = item.order)
        @item = item
        @wrapped_order = wrapped_order
      end

      def size
        if personalizations?
          personalization.size.try(:name) || 'Unknown Size'
        else
          variant.try(:dress_size).try(:name) || 'Unknown Size'
        end
      end

      def size_name
        size.split('/').detect {|s| s.downcase.include? order.site_version }
      rescue
        'Unknown Size'
      end

      def colour
        if personalizations?
          personalization.color
        else
          variant.try(:dress_color)
        end
      end

      def colour_name
        colour.try(:name) || 'Unknown Color'
      end

      def height
        personalizations? ? personalization.height : LineItemPersonalization::DEFAULT_HEIGHT
      end

      def customisation_text
        if item.customizations.present?
          JSON.parse(item.customizations).collect{|x| x['customisation_value']['presentation']}.join(' / ')
        end
      end
      alias_method :customization_text, :customisation_text

      # @deprecated #image? is deprecated. It is always true, since #image returns a `Repositories::Images::Template` instance
      def image?
        true
      end
      deprecate image?: '#image? is deprecated. It is always true, since #image returns a `Repositories::Images::Template` instance'

      def image_url
        image.large
      end

      # Note: a line item personalization can be nil
      # @return [Repositories::Images::Template]
      def image
        Repositories::LineItemImages.new(line_item: item).read(color_id: personalization&.color_id)
      end

      def sample_sale?
         !item.stock.nil?
      end

      def fabric_swatch?
        item.product.category.category == 'Sample'
      end

      def personalizations?
        personalization.present?
      end

      private

      def standard_variant_for_custom_color
        return unless personalizations?

        @standard_variant_for_custom_color ||= variant.product.variants.includes(:option_values).detect { |v|
          v.option_values.include?(personalization.color)
        }
      end
    end
  end
end
