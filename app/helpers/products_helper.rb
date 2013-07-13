module ProductsHelper
  def available_product_ranges
    range_taxonomy = Spree::Taxonomy.where(name: 'Range').first
    range_taxonomy.present? ? range_taxonomy.root.children : []
  end

  def available_product_styles
    range_taxonomy = Spree::Taxonomy.where(name: 'Style').first
    range_taxonomy.present? ? range_taxonomy.root.children : []
  end

  def available_product_colors
    color_option = Spree::Variant.color_option_type
    color_option.present? ? color_option.option_values : []
  end

  def product_short_description(product)
    product.property('short_description') || truncate(product.description, length: 50, separator: ' ')
  rescue
    'no description available'
  end

  def product_video(product, options = {})
    video_id = product.property('youtube_video_id') 
    return '' if video_id.blank?
    video_url = "//www.youtube.com/embed/#{video_id}"
    height  = options[:height] || 590
    width   = options[:width] || 600

    return %Q{<iframe width="#{width}" height="#{height}" src="#{video_url}" frameborder="0" allowfullscreen></iframe>}
  end

  def inspiration_image(product, options = {})
    image_src = product.property('inspiration_photo') || 'http://placehold.it/590x600'
    height  = options[:height] || 590
    #width   = options[:width] || 600

    image_tag image_src, height: height
  end

  def hoverable_product_image_tag(product, options = {})
    no_image = "noimage/product.png"
    if product.images.empty?
      image_tag no_image, options
    else
      images = product.images
      image = images.first
      options.reverse_merge! :alt => image.alt.blank? ? product.name : image.alt
      options[:mouseover] = images.second.attachment.url(:product) if images.size > 1
      options[:alt_image] = no_image
      image_tag image.attachment.url(:product), options
    end 
  end

  def add_to_wishlist_link(product_or_variant)
    variant = product_or_variant.is_a?(Spree::Product) ? product_or_variant.master : product_or_variant
    link_to 'Like item', '#', data: { action: 'add-to-wishlist', id: variant.id }
  end

  def quick_view_link(product)
    link_to 'Quick view', spree.product_path(product), data: { action: 'quick-view', id: product.permalink }
  end
end
