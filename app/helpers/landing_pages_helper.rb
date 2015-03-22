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
    product_color_value = product.product_color_values.detect{|v| v.images.any? }
    cropped_images =  product_color_value.images.select{ |i| i.attachment_file_name.to_s.downcase.include?('crop.jpg') }
    cropped_images.sort_by!{ |i| i.position }
    front = cropped_images.first
    hover =  cropped_images.last
    if front && hover
      image_tag front.attachment.url(:large), :alt => product.name, :class => "img-product img-responsive", 'data-hover' => hover.attachment.url(:large)
    else
      image_tag 'blank-product.png', :alt => product.name, :class => "img-product img-responsive"
    end
  end

end
