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
                     :refulfill

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
        colour.try(:presentation) || 'Unknown Color'
      end

      def fabric
        item.fabric
      end

      def fabric_name
        fabric.try(:name) || 'Unknown Fabric'
      end

      def fabric_material
        fabric.try(:material) || 'Unknown Fabric'
      end

      def height
        personalizations? ? personalization.height : LineItemPersonalization::DEFAULT_HEIGHT
      end

      def customization_text
        if item.customizations.present?
          JSON.parse(item.customizations)
            .sort_by { |x| x['customisation_value']['manifacturing_sort_order']}
            .collect{|x| x['customisation_value']['presentation']}.join(' / ')
        end
      end

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
        Repositories::LineItemImages.new(line_item: item).read(color_id: colour&.id, fabric_id: fabric&.id, fabric: fabric)
      end

      def sample_sale?
         !item.stock.nil?
      end

      # def refulfill_item?
      #   !item.refulfill.nil?
      # end

      # def refulfill_status
      #   item.refulfill_status
      # end

      def fabric_swatch?
        item.fabric_swatch?
      end

      def return_insurance?
        item.return_insurance?
      end

      def personalizations?
        personalization.present?
      end

      private

      def standard_variant_for_custom_color
        if fabric
          @standard_variant_for_custom_color ||= variant.product.variants.joins(:option_values).where(spree_option_values_variants: { option_value_id: fabric.option_fabric_color_value_id }).first
        end
      
        if personalization && personalization.color
          @standard_variant_for_custom_color ||= variant.product.variants.joins(:option_values).where(spree_option_values_variants: { option_value_id: personalization.color.id }).first
        end
      
        @standard_variant_for_custom_color
      end
    end
  end
end
