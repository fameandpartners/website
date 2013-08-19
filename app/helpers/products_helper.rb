module ProductsHelper
  def range_taxonomy
    @range_taxonomy ||= Spree::Taxonomy.where(name: 'Range').first
  end

  def range_taxon_for(product)
    return nil if range_taxonomy.blank?
    taxon = product.taxons.where(taxonomy_id: range_taxonomy.id).first
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

    width   = options[:width] || 300
    height  = options[:height] || 533

    "<iframe width='#{width}' height='#{height}' src='#{product.video_url}' frameborder='0' allowfullscreen></iframe>"
  end

  def hoverable_product_image_tag(product, options = {})
    no_image = "noimage/product.png"
    if product.images.empty?
      link_to image_tag(no_image, options), collection_product_path(product)
    else
      images = product.images
      image = images.first
      options.reverse_merge! :alt => image.alt.blank? ? product.name : image.alt
      if images.size > 1
        # original_image - quick fix for cdn & and empty attr['src']
        options[:original_image]  = image.attachment.url(:product)
        options[:second_image]    = images.second.attachment.url(:product)
      end
      options[:onerror] = "window.switchToAltImage(this, '/assets/#{no_image}')"
      link_to image_tag(image.attachment.url(:product), options), collection_product_path(product)
    end 
  end

  def quick_view_link(product)
    link_to 'Quick view', collection_product_path(product), data: { action: 'quick-view', id: product.permalink }
  end

  def add_to_bag_link(product_or_variant)
    if product_or_variant.is_a?(Spree::Product)
      # don't use master variant as default
      link_to 'Add to bag', '#', class: 'buy-now'
    else
      link_to 'Add to bag', '#', class: 'buy-now', data: { id: product_or_variant.id }
    end
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
      link_to 'Wish list', spree_signup_path, class: 'add-wishlist', data: { action: 'auth-required' }
    end
  end

  def in_wishlist?(variant)
    return current_wished_product_ids.include?(variant.product_id)
  end

  def share_buttons
    return '' if Rails.env.development?
    render 'shared/share_buttons'
  end

  def send_to_a_friend_link(product)
    if Rails.env.development?
      link_to 'Send to a Friend', '#', class: 'send-to-friend', data: { product: product.permalink }
    end
  end

  def wishlist_move_to_cart_link(wishlist_item)
    variant = wishlist_item.variant
    if variant.is_master?
      data = {
        variant: variant.id,
        item: wishlist_item.id,
        quantity: wishlist_item.quantity
      }
      link_to 'Add to cart', '#', class: 'add-to-cart master', data: data
    else
      link_to 'Add to cart', move_to_cart_wishlists_item_path(wishlist_item), class: 'add-to-cart', remote: true
    end
  end

  def product_move_to_wishlist_link(variant)
    if spree_user_signed_in?
      link_to 'Move to wish list', '#', data: { id: variant.id }, class: 'move-to-wishlist'
    else
      link_to 'Move to wish list', spree_signup_path
    end
  end
end
