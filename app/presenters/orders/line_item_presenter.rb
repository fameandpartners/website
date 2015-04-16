require 'forwardable'


module Orders

  class LineItemPresenter

    extend Forwardable
    def_delegators :@item, :quantity

    attr_reader :item

    def initialize(item)
      @item = item
    end

    def style_number
      item.variant.product.sku
    end

    def colour_name
      if item.personalization.present?
        item.personalization.color.try :name || 'Unknown Color'
      else
        item.variant.dress_color.name
      end
    end

    def size
      if item.personalization.present?
        item.personalization.size
      else
        item.variant.dress_size.name
      end
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
          customs << ["Custom Color: #{item.personalization.color.name}"]
        end

        customs
      else
        ['N/A']
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

    private

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