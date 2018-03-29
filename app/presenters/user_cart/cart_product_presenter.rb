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
      result[:fabric] = fabric if fabric.present?
      result[:from_wedding_atelier] = from_wedding_atelier
      result[:display_height] = display_height(height_value, height_unit, height)
      result[:customizations] =  (customizations ? JSON.parse(customizations.to_json) : []).map do |item|
        t = item['customisation_value']
        display_price = t['price'].to_f > 0 ? Spree::Money.new(t['price'].to_f) : Spree::Money.new(0)
        cart_summary = if from_wedding_atelier
          "#{t['customisation_type']}: #{t['presentation']} #{display_price} "
        else
          "#{t['name']} #{display_price} "
        end
        {
          id: t['id'],
          name: t['name'],
          display_price: display_price,
          cart_summary: cart_summary
        }
      end

      result[:making_options] = (making_options || []).map do |option|
        {
          id: option.id,
          name: option.name,
          display_price: option.display_price.to_s,
          display_discount: option.display_discount,
          delivery_period: option.delivery_period
        }
      end

      #filter out fastmaking option if non recommended color is chosen by user
      avo = (available_making_options.select {|x| !x.nil?} || []).map do |mo|
        if (mo.option_type == 'slow_making' && Features.active?(:delayed_delivery)) ||
            (mo.active && mo.option_type == 'fast_making' && color.present? && !color[:custom_color])
              if (mo.option_type == 'fast_making' && fabric.present? && fabric[:custom_fabric])
                nil
              else
               { id: mo.id, name: mo.name, display_discount: mo.display_discount, description: mo.description}
             end
        else
          nil
        end
      end

      result[:available_making_options] = avo.compact

      result
    end
  end
end
