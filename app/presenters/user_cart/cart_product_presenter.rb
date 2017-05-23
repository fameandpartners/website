module UserCart
  class CartProductPresenter < OpenStruct
    include ApplicationHelper

    def serialize
      result = self.marshal_dump.clone
      result[:price] = price.marshal_dump
      result[:discount] = discount if discount.present?
      result[:image] = image.marshal_dump if image.present?
      result[:size] = size.marshal_dump if size.present?
      result[:color] = color if color.present?
      result[:from_wedding_atelier] = from_wedding_atelier
      result[:display_height] = display_height(height_value, height_unit, height)
      result[:customizations] = (customizations || []).map do |t|
        display_price = t.price > 0 ? t.display_price : ''
        cart_summary = if from_wedding_atelier
          "#{t.customisation_type}: #{t.presentation} #{display_price} "
        else
          "#{t.name} #{display_price} "
        end

        {
          id: t.id,
          name: t.name,
          display_price: t.display_price,
          cart_summary: cart_summary
        }
      end

      result[:making_options] = (making_options || []).map do |option|
        { id: option.id, name: option.name, display_price: option.display_price.to_s, display_discount: option.display_discount }
      end

      #filter out fastmaking option if non recommended color is chosen by user
      avo = (available_making_options || []).map do |mo|
        if (mo.name == 'Deliver Later') || (color.present? && !color[:use_in_customisation])
          { id: mo.id, name: mo.name, display_discount: mo.display_discount, description: mo.description}
        else
          nil
        end
      end

      result[:available_making_options] = avo.compact

      result
    end
  end
end
