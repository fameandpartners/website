module LandingPagesHelper
  def disable_notices?
    @disable_notices.present? && @disable_notices == true
  end

  def cropped_product_hoverable_image_tag(product, css_class: "img-product img-responsive")
    front, hover = cropped_product_hoverable_images(product)

    image_tag front,
              :alt         => product.name,
              :class       => css_class,
              'data-hover' => hover
  end

  # TODO - Remove the need for this for displaying wishlist items.
  def cropped_product_color_variant_image_tag(color_variant)
    front, hover = Products::ColorVariantImageDetector.cropped_images_for(color_variant).collect { |i| i.attachment.url(:large) }
    if front && hover
      image_tag front, 'data-hover' => hover, class: "img-product img-responsive"
    else
      cropped_product_hoverable_image_tag(color_variant.product)
    end
  end

  # Attempts to load "CROP" style images, falls back to
  # just "FRONT" images for old products which weren't re-shot in the Early 2015 style.
  def cropped_product_hoverable_images(product)
    product.product_color_values.collect do |color_variant|
      images = Products::ColorVariantImageDetector.cropped_images_for(color_variant).collect { |i| i.attachment.url(:large) }
      images if images.size == 2
    end.compact.sample
  end
end
