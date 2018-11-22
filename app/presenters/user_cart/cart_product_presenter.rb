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
      result[:color_price_cents] = color[:custom_color] ? (LineItemPersonalization::DEFAULT_CUSTOM_COLOR_PRICE * 100).to_i : 0 if color.present?
      result[:fabric] = fabric if fabric.present?
      result[:display_height] = display_height(height_value, height_unit, height)
      result[:customizations] =  (customizations ? JSON.parse(customizations.to_json) : []).map do |item|
        t = item['customisation_value']
        display_price = t['price'].to_f > 0 ? Spree::Money.new(t['price'].to_f) : Spree::Money.new(0)
        cart_summary = "#{t['name']} #{display_price}  "

        {
          id: t['id'],
          name: t['name'],
          presentation: t['presentation'],
          display_price: display_price,
          cart_summary: cart_summary
        }
      end


      result
    end
  end
end
