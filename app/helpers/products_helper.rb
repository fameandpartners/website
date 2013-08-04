module ProductsHelper
  def range_taxonomy
    @range_taxonomy ||= Spree::Taxonomy.where(name: 'Range').first
  end

  def available_product_ranges
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
    description_text = product.property('short_description') || product.description
    truncate(description_text, length: 80, separator: ' ')
  rescue
    t('product_has_no_description')
  end

  def product_video(product, options = {})
    return '' if Rails.env.development?
    return '' if product.video_url.blank?

    height  = options[:height] || 590
    width   = options[:width] || 600

    "<iframe width='#{width}' height='#{height}' src='#{product.video_url}' frameborder='0' allowfullscreen></iframe>"
  end

  def hoverable_product_image_tag(product, options = {})
    no_image = "noimage/product.png"
    if product.images.empty?
      link_to image_tag(no_image, options), spree.product_path(product)
    else
      images = product.images
      image = images.first
      options.reverse_merge! :alt => image.alt.blank? ? product.name : image.alt
      options[:second_image] = images.second.attachment.url(:product) if images.size > 1
      options[:onerror] = "window.switchToAltImage(this, '/assets/#{no_image}')"
      link_to image_tag(image.attachment.url(:product), options), spree.product_path(product)
    end 
  end

  def quick_view_link(product)
    link_to 'Quick view', spree.product_path(product), data: { action: 'quick-view', id: product.permalink }
  end

  def add_to_bag_link(product_or_variant)
    variant = product_or_variant.is_a?(Spree::Product) ? product_or_variant.master : product_or_variant
    link_to 'Add to bag', '#', class: 'buy-now', data: { id: variant.id }
  end

  def add_to_wishlist_link(product_or_variant)
    if spree_user_signed_in?
      variant = product_or_variant.is_a?(Spree::Product) ? product_or_variant.master : product_or_variant

      link_options = { data: { action: 'add-to-wishlist', id: variant.id }}
      if in_wishlist?(variant)
        link_to 'Remove', '#', link_options.merge(class: 'active add-wishlist')
      else
        link_to 'Wish list', '#', link_options.merge(class: 'add-wishlist')
      end
    else # user not logged in, wishlist unavailable
      link_to 'Wish list', spree_login_path, class: 'add-wishlist', data: { action: 'auth-required' }
    end
  end

  def in_wishlist?(variant)
    user = try_spree_current_user
    return false if user.blank?

    return user.wishlist_items.where(spree_product_id: variant.product_id).exists?
  end

  def share_buttons
    return '' if Rails.env.development?
    render 'shared/share_buttons'
  end
end
