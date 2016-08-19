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
                   :fast_making?,
                   :factory,
                   :fabrication,
                   :price,
                   :currency,
                   :quantity

    def shipment
      @shipment ||= wrapped_order.shipments.detect { |ship| ship.line_items.include?(@item) } || NoShipment.new
    end

    def style_number
      variant.try(:product).try(:sku) || 'Missing Product'
    end

    def sku
      if personalizations?
        CustomItemSku.new(item).call
      else
        variant.sku
      end
    end

    def global_sku
      @global_sku ||= GlobalSku.find_or_create_by_line_item(line_item_presenter: self)
    end

    def product_number
      global_sku.id
    end

    def style_name
      variant.try(:product).try(:name) || 'Missing Variant'
    end

    def projected_delivery_date
      return unless wrapped_order.order.completed?
      @projected_delivery_date ||= Policies::LineItemProjectedDeliveryDatePolicy.new(
        @wrapped_order.order.completed_at, @item.fast_making?).delivery_date.try(:to_date)
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

    def display_amount
      item.display_amount.to_s
    end

    def customisations
      if personalizations?
        customs = Array.wrap(
            personalization.customization_values.collect { |custom|
              [custom.presentation, custom.image]
            }
        )

        unless standard_variant_for_custom_color.present?
          customs << ["Custom Color: #{colour_name}"]
        end

        customs
      else
        [['N/A']]
      end
    end

    def customisations_without_images
      customisations.collect &:first
    end

    def customisation_ids
      return [] unless personalizations?
      Array.wrap(personalization.customization_values.collect(&:id))
    end

    def customisation_names
      return [] unless personalizations?
      Array.wrap(personalization.customization_values.collect(&:presentation))
    end

    def return_action
      if order.return_requested? && return_item
        return_item.action
      end
    end

    def return_details
      if order.return_requested? && return_item
        if return_item.return_or_exchange?
          "#{return_item.quantity} x #{return_item.reason_category} - #{return_item.reason}"
        end
      end
    end

    def return_item
      @return_item ||= order.return_request.return_request_items.where(:line_item_id => id).first
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

  end
end
