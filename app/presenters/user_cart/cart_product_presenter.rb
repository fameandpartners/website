module UserCart
  class CartProductPresenter < OpenStruct
    include ApplicationHelper


    COLOR_MAP = {
      'Bright Turquoise' => '0000',
      'Pale Blue' => '0001',
      'Blush' =>'0002',
      'Guava' => '0003',
      'Burgundy' => '0004',
      'Champagne' => '0005',
      'Ivory' => '0006',
      'Lilac' => '0007',
      'Mint' => '0008',
      'Pale Grey' => '0009',
      'Pale Pink' => '0010',
      'Peach' => '0011',
      'Red' => '0012',
      'Royal Blue' => '0013',
      'Black' => '0014',
      'Sage Green' => '0015',
      'Berry'=> '0016',
      'Navy' => '0017',
    }

    def  serialize
      result = self.marshal_dump.clone
      result[:price] = price.marshal_dump
      result[:discount] = discount if discount.present?
      result[:image] = generate_image
      result[:size] = size.marshal_dump if size.present?
      result[:color] = color if color.present?
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
          { id: mo.id, name: mo.name, display_discount: mo.display_discount, description: mo.description}
        else
          nil
        end
      end

      result[:available_making_options] = avo.compact

      result
    end

    private

    def generate_image
      if brides_maid
        customization_ids = customizations.reject{|y| y['customisation_value']['id'][0].downcase == 'l'}.map{|x| x['customisation_value']['id']}.sort.join('-')
        customization_ids = customization_ids.blank? ? 'default' : customization_ids
        return {
                :id => 0,
          :position => 0,
          :original => "http://d1h7wjzwtdym94.cloudfront.net/renders/composites/#{sku.downcase}/142x142/#{customization_ids}-#{length.downcase}-front-#{COLOR_MAP[color[:presentation]]}.png",
             :large => "http://d1h7wjzwtdym94.cloudfront.net/renders/composites/#{sku.downcase}/142x142/#{customization_ids}-#{length.downcase}-front-#{COLOR_MAP[color[:presentation]]}.png",
            :xlarge => "http://d1h7wjzwtdym94.cloudfront.net/renders/composites/#{sku.downcase}/800x800/#{customization_ids}-#{length.downcase}-front-#{COLOR_MAP[color[:presentation]]}.png",
             :small => "http://d1h7wjzwtdym94.cloudfront.net/renders/composites/#{sku.downcase}/142x142/#{customization_ids}-#{length.downcase}-front-#{COLOR_MAP[color[:presentation]]}.png" 
        }
      else
        return image.marshal_dump if image.present?
      end
    end
  end
end
