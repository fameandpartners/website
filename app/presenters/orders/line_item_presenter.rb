# encoding: utf-8

module Orders
  class LineItemPresenter < Orders::Shared::LineItemPresenter
    class NoShipment
      def shipped?
        false
      end
      def shipped_at
        nil
      end

      def tracking
        'NoShipment'
      end

      def present?
        false
      end
    end

    def_delegators :shipment, :shipped?, :shipped_at, :tracking_number
    def_delegator :shipment, :tracking, :tracking_number
    def_delegators :@wrapped_order,
                   :number,
                   :total_items,
                   :shipping_address,
                   :promo_codes

    def_delegators :@item,
                   :id,
                   :making_options,
                   :making_option,
                   :factory,
                   :fabrication,
                   :price,
                   :currency,
                   :quantity,
                   :style_name,
                   :projected_delivery_date,
                   :ship_by_date

    def delivery_period
      @item.delivery_period
    end

    def shipment
      @item.shipment || NoShipment.new
    end

    def style_number
      variant.try(:product).try(:sku) || 'Missing Product'
    end

    def sku
      if personalizations?
        CustomItemSku.new(item).call
      else
        variant&.sku
      end
    end

    def global_sku
      @global_sku ||= GlobalSku.find_or_create_by_line_item(line_item_presenter: self)
    end

    def extended_style_number
      global_sku.data.try(:[], 'extended-style-number')
    end

    def product_number
      item.upc || global_sku.id
    end

    def fabrication_status
      if fabrication
        fabrication.state
      else
        :processing
      end
    end

    def country_size
      "#{size} (#{order.site_version})"
    end

    def display_price
      Spree::Price.new(amount: price).display_price.to_s
    end

    def customisations(include_codes: false)
      if personalizations?
        if item.customizations
          customs = Array.wrap(
              item.customizations
              .sort_by { |x| x['customisation_value']['manifacturing_sort_order']}
              .collect { |custom|
                [
                  format_customisation(customization: custom, include_codes: include_codes),
                  custom['customisation_value']['image']
                ]
              }
          )
        else
          customs = Array.wrap(
              personalization.customization_values.collect { |custom|
                [
                  format_customisation(customization: custom, include_codes: include_codes),
                  custom['customisation_value']['image']
                ]
              }
          )
        end

        customs
      else
        [['N/A']]
      end
    end

    def customisations_presentations(include_codes: false)
      customisations(include_codes: include_codes).collect &:first
    end

    def variant_id
      variant.try(:id)
    end

    def product_id
      variant.try(:product_id)
    end

    def colour_id
      colour.try(:id)
    end
    
    def refulfill_status
      item.refulfill_status
    end

    def format_customisation(customization:, include_codes: false)
      if include_codes && Spree::Product.is_new_product?(style_number)
        "#{customization['customisation_value']['name']} #{customization['customisation_value']['presentation']}"
      else
        customization['customisation_value']['presentation']
      end
    end

  end
end
