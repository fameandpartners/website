module UserCart
  class CartProductPresenter < OpenStruct
    def serialize
      result = self.marshal_dump.clone

      result[:price] = price.marshal_dump
      result[:discount] = discount if discount.present?
      result[:image] = image.marshal_dump if image.present?
      result[:size] = size.marshal_dump if size.present?
      result[:color] = color if color.present?

      result[:customizations] = (customizations || []).map do |t|
        { id: t.id, name: t.name, display_price: t.display_price.to_s }
      end

      result[:making_options] = (making_options || []).map do |option|
        { id: option.id, name: option.name, display_price: option.display_price.to_s }
      end

      result
    end
  end
end
