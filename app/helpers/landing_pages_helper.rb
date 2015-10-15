module LandingPagesHelper
  def disable_notices?
    @disable_notices.present? && @disable_notices == true
  end

  def cropped_product_hoverable_image_tag(product)
    front, hover = cropped_product_hoverable_images(product)

    image_tag front,
              :alt         => product.name,
              :class       => "img-product img-responsive",
              'data-hover' => hover
  end

  # Attempts to load "CROP" style images, falls back to
  # just "FRONT" images for old products which weren't re-shot in the Early 2015 style.
  def cropped_product_hoverable_images(product)
    product.product_color_values.collect do |color_variant|
      images = Products::ColorVariantImageDetector.cropped_images_for(color_variant)
      images if images.size == 2
    end.compact.sample
  end
end
