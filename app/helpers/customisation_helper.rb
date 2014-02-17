module CustomisationHelper
  def product_customisation_value_image(product_customisation_value)
    if product_customisation_value.image.present?
      image_url = product_customisation_value.image.url
    elsif product_customisation_value.customisation_value.image.present?
      image_url = product_customisation_value.customisation_value.image.url
    elsif Rails.env.development?
      image_url = 'http://placehold.it/240x240'
    end
    if image.url.present?
      image_tag(image_url, alt: product_customisation_value.presentation, title: product_customisation_value.presentation)
    else
      ''
    end
  end
end
