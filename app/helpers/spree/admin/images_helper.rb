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
    end
  end
end

