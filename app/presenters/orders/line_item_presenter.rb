require 'forwardable'


module Orders
  class LineItemPresenter
    extend Forwardable
    def_delegators :@item, :quantity

    attr_reader :item, :order

    def initialize(item, order)
      @item = item
      @order = order
    end

    def style_number
      item.variant.product.sku
    end

    def colour_name
      if item.personalization.present?
        item.personalization.color
      else
        item.variant.dress_color
      end.try(:name) || 'Unknown Color'
    end

    def country_size
      "#{order.country_code}-#{size}"
    end

    def factory
      Factory.for_product(item.variant.product)
    end

    def customisations
      if personalizations?
        customs = Array.wrap(
            item.personalization.customization_values.collect { |custom|
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
      item.personalization.present?
    end

    def image?
      image.present?
    end

    def image_url
      image.attachment.url(:large)
    end

    def as_report
      {
        :order_number            => order.number,
        :total_items             => order.total_items,
        :completed_at            => order.completed_at.to_date,
        :projected_delivery_date => order.projected_delivery_date,
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

    private

    def size
      if item.personalization.present?
        item.personalization.size
      else
        item.variant.dress_size.name
      end
    end

    # Seriously, wtf are custom dresses so hard?
    def image
      @image ||= begin
        image = variant_image(item.variant)

        # Customised dresses use the master variant, find the closest
        # matching standard variant, use those images
        if personalizations? && !image.present? && standard_variant_for_custom_color
          image = variant_image(standard_variant_for_custom_color)
        end

        # We won't find a colour variant for custom colours, so
        # fallback to whatever product image.
        unless image.present?
          image = cropped_images_for(item.variant.product.images)
        end

        image
      rescue NoMethodError
        Rails.logger.warn("Failed to find image for order email. #{item.order.to_s}")
      end
    end

    def standard_variant_for_custom_color
      return unless personalizations?

      @standard_variant_for_custom_color ||= item.variant.product.variants.detect { |v|
        v.option_values.include?(item.personalization.color)
      }
    end

    def variant_image(variant)
      cropped_images_for(item.variant.product.images_for_variant(variant))
    end

    def cropped_images_for(image_set)
      image_set.select { |i| i.attachment.url(:large).downcase.include?('front-crop') }.first
    end
  end
end