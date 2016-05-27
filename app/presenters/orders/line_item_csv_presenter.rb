module Orders
  class LineItemCSVPresenter

    attr_reader :line

    def initialize(line)
      @line = line
    end

    %w(
        order_state order_number line_item_id total_items completed_at_date tracking_number
        shipment_date fabrication_state style promo_codes email customer_notes currency
        site_version quantity size personalization custom_variant_id
      ).each do |attr|
      define_method(attr) { line["#{attr}"] }
    end

    def style_name
      line['style_name'] || 'Missing Variant'
    end

    def factory
      line['factory'] || 'Unknown'
    end

    def adjusted_size
      (size || 'Unknown Size')  + " (#{site_version})"
    end

    def height
      line['height'] || LineItemPersonalization::DEFAULT_HEIGHT
    end

    def fast_making
      line['fast_making'].present? ? "TRUE" : ''
    end

    def customer_name
      "#{line['user_first_name']} #{line['user_last_name']}"
    end

    def shipping_address
      shipping_address_line.present? ? shipping_address_line : 'No Shipping Address'
    end

    def customer_phone_number
      line['customer_phone_number'] || 'No Phone'
    end

    def price
      line['price'].to_f + line['personalization_price'].to_f + line['making_options_price'].to_f
    end

    def color
      line['color'] || 'Unknown Color'
    end

    def customization_values
      if personalization.present?
        values = YAML.load(line['customization_value_ids'])
        customs = values.present? ? CustomisationValue.where(id: values).pluck(:presentation) : []
        customs.join('|')
      else
        'N/A'
      end
    end

    def custom_color
      color if personalization.present? && !line['custom_color'].present?
    end

    def delivery_date
      return unless line['completed_at_date'].present?
      Policies::LineItemProjectedDeliveryDatePolicy.new(line['completed_at_date'].to_date, line['fast_making']).delivery_date
    end

    def return_request
      line['return_action_details'].present? ? 'true' : 'false'
    end

    def return_action
      line['return_action_details'].try(:split, '/').try(:[], 0)
    end

    def return_details
      line['return_action_details'].try(:split, '/').try(:[], 1)
    end

    def image
      image = line['variant_image']

      # Customised dresses use the master variant, find the closest
      # matching standard variant, use those images
      if personalization.present? && !image.present? && custom_variant_id.present?
        image = line['custom_variant_image']
      end

      # We won't find a colour variant for custom colours, so
      # fallback to whatever product image.
      image = line['product_image'] unless image.present?

      "http://images.fameandpartners.com/spree/products/#{image}" if image
    end

    private

    def shipping_address_line
      "#{line['address1']} #{line['address2']} #{line['city']} #{line['state']} #{line['zipcode']} #{line['country']}"
    end

  end
end
