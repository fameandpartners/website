module UserCart
  class CartProductPresenter < OpenStruct
    def serialize
      result = self.marshal_dump.clone
      result[:price] = price.marshal_dump
      result[:discount] = discount if discount.present?
      result[:image] = image.marshal_dump if image.present?
      result[:size] = size.marshal_dump if size.present?
      result[:color] = color.marshal_dump if color.present?
      result[:from_wedding_atelier] = from_wedding_atelier
      result[:height_title] = height_title
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
        { id: option.id, name: option.name, display_price: option.display_price.to_s }
      end

      result
    end
  end
end
