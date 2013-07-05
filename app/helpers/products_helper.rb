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
end
