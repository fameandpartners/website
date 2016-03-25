# encoding: utf-8

require 'forwardable'

module Orders
  class LineItemPresenter
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
    extend Forwardable

    def_delegators :shipment, :shipped?, :shipped_at, :tracking_number
    def_delegator :shipment, :tracking, :tracking_number
    def_delegators :@wrapped_order,
                   :number,
                   :total_items,
                   :shipping_address,
                   :promo_codes

    def_delegators :@item,
                   :id,
                   :variant,
                   :personalization,
                   :making_options,
                   :fast_making?,
                   :factory,
                   :fabrication,
                   :price,
                   :quantity

    attr_reader :wrapped_order, :item

    def initialize(item, wrapped_order)
      @item = item
      @wrapped_order = wrapped_order
    end

    def shipment
      @shipment ||= wrapped_order.shipments.detect { |ship| ship.line_items.include?(@item) } || NoShipment.new
    end

    alias_method :order, :wrapped_order

    def style_number
      variant.try(:product).try(:sku) || 'Missing Product'
    end

    def sku
      if personalization.present?
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
      @projected_delivery_date ||= Policies::LineItemProjectedDeliveryDatePolicy.new(@item, @wrapped_order).delivery_date.try(:to_date)
    end

    def fabrication_status
      if fabrication
        fabrication.state
      else
        :processing
      end
    end

    def colour
      if personalization.present?
        personalization.color
      else
        variant.try(:dress_color)
      end
    end

    def colour_name
      colour.try(:name) || 'Unknown Color'
    end

    def country_size
      "#{size} (#{order.site_version})"
    end

    def height
      return LineItemPersonalization::DEFAULT_HEIGHT unless personalizations?
      personalization.height
    end

    def display_price
      Spree::Price.new(amount: price).display_price.to_s
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

    def personalizations?
      personalization.present?
    end

    def image?
      image.present?
    end

    def image_url
      image? ? image.attachment.url(:large) : nil
    end

    def as_report
      {
        :order_state             => order.state,
        :order_number            => number,
        :line_item               => id,
        :total_items             => total_items,
        :completed_at            => order.completed_at.try(:to_date),
        :express_making          => fast_making? ? "TRUE" : '',
        :projected_delivery_date => projected_delivery_date,
        :tracking_number         => tracking_number,
        :shipment_date           => shipped_at.try(:to_date),
        :fabrication_state       => fabrication_status,
        :sku                     => sku,
        :style                   => style_number,
        :style_name              => style_name,
        :factory                 => factory,
        :color                   => colour_name,
        :size                    => country_size,
        :height                  => height,
        :customisations          => customisations.collect(&:first).join('|'),
        :promo_codes             => promo_codes.join('|'),
        :customer_notes          => order.customer_notes,
        :customer_name           => order.name,
        :customer_phone_number   => wrapped_order.phone_number.to_s,
        :shipping_address        => wrapped_order.shipping_address,
        :return_request          => order.return_requested?,
        :return_action           => return_action,
        :return_details          => return_details
      }
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

    def headers

      cn_headers = {
        order_number:            '(订单号码)',
        completed_at:            '(订单日期)',
        express_making:          '(快速决策)',
        projected_delivery_date: '(要求出厂日期)',
        tracking_number:         '(速递单号)',
        style:                   '(款号)',
        factory:                 '(工厂)',
        color:                   '(颜色)',
        size:                    '(尺寸)',
        customisations:          '(特殊要求)',
        customer_name:           '(客人名字)',
        customer_phone_number:   '(客人电话)',
        shipping_address:        '(客人地址)'
      }

      as_report.keys.collect { |k| "#{k} #{cn_headers[k]}" }
    end

    def size
      if personalization.present?
        personalization.size.try(:name) || 'Unknown Size'
      else
        variant.try(:dress_size).try(:name) || 'Unknown Size'
      end
    end


    # Seriously, wtf are custom dresses so hard?
    def image
      @image ||= begin
        image = variant_image(variant)

        # Customised dresses use the master variant, find the closest
        # matching standard variant, use those images
        if personalizations? && !image.present? && standard_variant_for_custom_color
          image = variant_image(standard_variant_for_custom_color)
        end

        # We won't find a colour variant for custom colours, so
        # fallback to whatever product image.
        unless image.present?
          image = cropped_images_for(variant.product.images)
        end

        image
      rescue NoMethodError
        Rails.logger.warn("Failed to find image for order email. #{wrapped_order.to_s}")
      end
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

    private


    def standard_variant_for_custom_color
      return unless personalizations?

      @standard_variant_for_custom_color ||= variant.product.variants.includes(:option_values).detect { |v|
        v.option_values.include?(personalization.color)
      }
    end

    def variant_image(variant)
      cropped_images_for(variant.product.images_for_variant(variant))
    end

    def cropped_images_for(image_set)
      image_set.select { |i| i.attachment.url(:large).downcase.include?('front-crop') }.first
    end
  end
end
