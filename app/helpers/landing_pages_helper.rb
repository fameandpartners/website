module LandingPagesHelper
 require "base64"

  def pop?
    params[:pop].present? && params[:pop] == 'true'
  end

  def decode(p)
    if p.present?
      Base64.decode64(p)
    else
      ''
    end
  end

   def cropped_product_hoverable_image_tag(product)
     image_urls = cropped_product_hoverable_images(product)

     image_tag image_urls.first, :alt => product.name, :class => "img-product img-responsive", 'data-hover' => image_urls.last
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
