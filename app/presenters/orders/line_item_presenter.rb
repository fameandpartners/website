# encoding: utf-8
require 'forwardable'


module Orders
  class LineItemPresenter < DelegateClass(Spree::LineItem)

    delegate :id, :to => :__getobj__

    extend Forwardable
    def_delegators :@shipment, :shipped?, :shipped_at
    def_delegators :@order,
                   :projected_delivery_date,
                   :tracking_number,
                   :number,
                   :total_items,
                   :shipping_address

    attr_reader :order, :shipment

    def initialize(item, order)
      @order = order
      @shipment ||= @order.shipments.detect { |ship| ship.line_items.include?(item) }

      super(item)
    end

    def style_number
      variant.product.sku
    end

    def style_name
      variant.product.name
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

    def factory
      Factory.for_product(variant.product)
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
        :order_number            => number,
        :total_items             => total_items,
        :completed_at            => order.completed_at.to_date,
        :projected_delivery_date => projected_delivery_date,
        :tracking_number         => tracking_number,
        :style                   => style_number,
        :factory                 => factory,
        :color                   => colour_name,
        :size                    => country_size,
        :customisations          => customisations.collect(&:first).join('|'),
        :promo_codes             => order.promo_codes.join('|'),
        :customer_name           => order.name,
        :customer_phone_number   => order.phone_number.to_s,
        :shipping_address        => order.shipping_address
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


    private

    def size
      if personalization.present?
        personalization.size
      else
        variant.dress_size.name
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
        Rails.logger.warn("Failed to find image for order email. #{order.to_s}")
      end
    end

    def standard_variant_for_custom_color
      return unless personalizations?

      @standard_variant_for_custom_color ||= variant.product.variants.detect { |v|
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
