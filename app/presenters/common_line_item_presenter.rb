require 'forwardable'

class CommonLineItemPresenter

  attr_reader :item, :wrapped_order
  alias_method :order, :wrapped_order

  extend Forwardable
  def_delegators :@item,
                 :variant,
                 :personalization

  def initialize(item, wrapped_order)
    @item = item
    @wrapped_order = wrapped_order
  end

  def size
    if personalizations?
      personalization.size.try(:name) || 'Unknown Size'
    else
      variant.try(:dress_size).try(:name) || 'Unknown Size'
    end
  end

  def size_name
    size.split('/').detect {|s| s.downcase.include? order.site_version }
  rescue
    'Unknown Size'
  end

  def colour
    if personalizations?
      personalization.color
    else
      variant.try(:dress_color)
    end
  end

  def colour_name
    colour.try(:name) || 'Unknown Color'
  end

  def height
    personalizations? ? personalization.height : LineItemPersonalization::DEFAULT_HEIGHT
  end

  def customisation_text
    if personalizations?
      personalization.customization_values.collect(&:presentation).join(' / ')
    end
  end

  def image?
    image.present?
  end

  def image_url
    image? ? image.attachment.url(:large) : nil
  end

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

  def personalizations?
    personalization.present?
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
