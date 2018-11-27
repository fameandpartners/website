module ProductsHelper
  def range_taxonomy
    @range_taxonomy ||= Spree::Taxonomy.where(name: 'Range').first
  end

  def available_product_ranges
    range_taxonomy.present? ? range_taxonomy.root.children : []
  end
  def product_image_tag(product, size = nil, options = {})
    no_image = 'noimage/product.png'
    size = size.present? ? size : 'large'

    options[:title] ||= product.name

    if product.images.empty?
      image_tag(no_image, options)
    else
      image = product.images.first
      options.reverse_merge! alt: image.alt.blank? ? product.name : image.alt

      image_tag(image.attachment.url(size), options)
    end
  end

end
