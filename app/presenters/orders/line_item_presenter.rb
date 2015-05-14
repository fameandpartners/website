# encoding: utf-8

require 'forwardable'

module Orders
  class LineItemPresenter
    extend Forwardable

    def_delegators :shipment, :shipped?, :shipped_at
    def_delegators :@wrapped_order,
                   :tracking_number,
                   :number,
                   :total_items,
                   :shipping_address,
                   :promo_codes

    def_delegators :@item,
                   :id,
                   :variant,
                   :personalization,
                   :factory,
                   :fabrication,
                   :price,
                   :quantity

    attr_reader :wrapped_order

    def initialize(item, wrapped_order)
      @item = item
      @wrapped_order = wrapped_order
    end

    def shipment
      @shipment ||= wrapped_order.shipments.detect { |ship| ship.line_items.include?(@item) }
    end

    alias_method :order, :wrapped_order

    def style_number
      variant.try(:product).try(:sku) || 'Missing Product'
    end

    def style_name
      variant.try(:product).try(:name) || 'Missing Variant'
    end

    def projected_delivery_date
      @_projected_delivery_date ||= Policies::LineItemProjectedDeliveryDatePolicy.new(@item, wrapped_order).delivery_date
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
        variant.dress_color
      end
    end

    def colour_name
      colour.try(:name) || 'Unknown Color'
    end

    def country_size
      "#{order.site_version}-#{size}"
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

    def personalizations?
      personalization.present?
    end

    def image?
      image.present?
    end

    def image_url
      image.attachment.url(:large)
    end

    def as_report
      {
        :order_state             => order.state,
        :order_number            => number,
        :line_item               => id,
        :total_items             => total_items,
        :completed_at            => order.completed_at.to_date,
        :projected_delivery_date => projected_delivery_date,
        :tracking_number         => tracking_number,
        :shipment_date           => shipped_at.try(:to_date),
        :style                   => style_number,
        :factory                 => factory,
        :color                   => colour_name,
        :size                    => country_size,
        :customisations          => customisations.collect(&:first).join('|'),
        :promo_codes             => promo_codes.join('|'),
        :customer_notes          => order.customer_notes,
        :customer_name           => order.name,
        :customer_phone_number   => wrapped_order.phone_number.to_s,
        :shipping_address        => wrapped_order.shipping_address
      }
    end

    def headers

      cn_headers = {
        order_number:            '(订单号码)',
        completed_at:            '(订单日期)',
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
        personalization.size
      else
        variant.dress_size.try(:name) || 'Unknown Size'
      end
    end

    private
    
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
