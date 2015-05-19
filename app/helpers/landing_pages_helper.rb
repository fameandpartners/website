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
    product_color_value = product.product_color_values.detect { |v| v.images.any? }
    cropped_images = product_color_value.images.select { |i| i.attachment_file_name.to_s.downcase.include?('crop.jpg') }
    cropped_images.sort_by! { |i| i.position }
    front = cropped_images.first
    hover = cropped_images.last

    fail_over_image = product_color_value.images.select { |i| i.attachment_file_name.to_s.downcase.include?('front') }.first

    if front && hover
      [front.attachment.url(:large), hover.attachment.url(:large)]
    elsif fail_over_image.present?
      [fail_over_image.attachment.url(:large), fail_over_image.attachment.url(:large)]
    else
      Rails.logger.info("Missing images for product id=#{product.id} name=#{product.name}")
      ['blank-product.png']
    end
  end
end
