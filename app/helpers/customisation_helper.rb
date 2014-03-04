module CustomisationHelper
  def product_customisation_value_image(customisation_value)
    if customisation_value.image.present?
      image_url = customisation_value.image.url
    elsif Rails.env.development?
      image_url = 'http://placehold.it/240x240'
    end
    if image_url.present?
      image_tag(image_url, alt: customisation_value.presentation, title: customisation_value.presentation)
    else
      ''
    end
  end
end
