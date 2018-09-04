module Orders
  class LineItemCSVPresenter
    class << self
      PRODUCTS_TO_IGNORE = [
        'return_insurance',
        'sw'
      ]

      attr_reader :line

      def set_line(line)
        @line = line
        @item = nil
      end

      %w(
          order_state order_number line_item_id total_items completed_at_date tracking_number
          shipment_date fabrication_state style promo_codes email customer_notes currency
          site_version quantity size personalization custom_variant_id address1 address2
          city state zipcode country color_id
        ).each do |attr|
        define_method(attr) { line["#{attr}"] }
      end

      def style_name
        line['curation_name'] || line['style_name'] || 'Missing Variant'
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
        if !item&.stock.nil?
          return line['price'].to_f + line['making_options_price'].to_f
        else
          return line['price'].to_f + line['personalization_price'].to_f + line['making_options_price'].to_f
        end
      end

      def color
        line['color'] || 'Unknown Color'
      end

      def customization_values #TODO: Need to address this situation
        if personalization.present?
          customs = JSON.parse(item.customizations)
            .sort_by { |x| x['customisation_value']['manifacturing_sort_order']}
            .map {|x| format_customisation(customization: x, include_codes: true)}
          if customs.empty?
            customs = customization_value_ids.present? ? CustomisationValue.where(id: customization_value_ids).pluck(:presentation) : []
          end
          customs.join('|')
        else
          'N/A'
        end
      end

      def item
        @item ||= Spree::LineItem.find(line['line_item_id'])
      end

      def custom_color
        color if personalization.present? && !line['custom_color'].present?
      end

      def material
        line['material']
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
        if Spree::Product.is_new_product?(style)
          return Spree::Product.format_render_url(style, item.fabric&.name || item.color, JSON.parse(item.customizations))
        end

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

      def product_number
        item&.upc || global_sku&.id
      end

      def sku
        global_sku&.sku
      end

      def ignore_line?
        PRODUCTS_TO_IGNORE.include?(style.downcase)
      end

      def production_sheet_url
        if Spree::Product.is_new_product?(style)
          pid = Spree::Product.format_new_pid(
            style,
            item.fabric&.name || item.color,
            JSON.parse(item.customizations)
          )

          "#{configatron.product_catalog_url}/admin/productionsheet/#{pid}"
        end
      end

      private

      def shipping_address_line
        "#{address1} #{address2} #{city} #{state} #{zipcode} #{country}"
      end

      def global_sku
        if item
          lip = Orders::LineItemPresenter.new(item)
          GlobalSku.find_or_create_by_line_item(line_item_presenter: lip)
        else
          nil
        end
      end

      def variant_sku
        line['variant_sku']
      end

      def customization_value_ids
        YAML.load(line['customization_value_ids']) if line['customization_value_ids'].present?
      end

      def format_customisation(customization:, include_codes: false)
        if include_codes && Spree::Product.is_new_product?(style)
          "#{customization['customisation_value']['name']} #{customization['customisation_value']['presentation']}"
        else
          customization['customisation_value']['presentation']
        end
      end

    end
  end
end
