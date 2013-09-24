module Spree
  module Admin
    module ImagesHelper
      def options_text_for(image)
        if image.viewable.is_a?(Spree::Variant)
          if image.viewable.is_master?
            I18n.t(:all)
          else
            image.viewable.options_text
          end
        elsif image.viewable.is_a?(ProductColorValue)
          "#{I18n.t(:color)}: #{image.viewable.option_value.presentation}"
        end
      end

      def viewable_type_from_image(image)
        case image.viewable_type
        when 'ProductColorValue'
          "option_value_#{image.viewable.option_value.id}"
        when 'Spree::Variant'
          "variant_#{image.viewable_id}"
        end
      end

      def viewable_by_id(product, id)
        viewable_type, nop, viewable_id = id.rpartition('_')
        viewable = case viewable_type
        when 'option_value'
          product.product_color_values.where(option_value_id: viewable_id).first_or_create
        else
          Spree::Variant.find(viewable_id)
        end
      end
    end
  end
end

