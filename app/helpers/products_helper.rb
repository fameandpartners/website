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

  def seo_taxonomy
    @seo_taxonomy ||= Spree::Taxonomy.where("lower(name) = ?", 'SeoCollection'.downcase).first
  end

  def available_seo_taxonomy_urls
    seo_taxonomy.present? ? seo_taxonomy.root.children : []
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

  def customize_this_dress(product)
    content_tag :div, class: 'customize' do
      mail = mail_to "team@fameandpartners.com?subject=I would like to customise this dress: #{product.sku}", 'Free Customisation'
      dropdown = content_tag :div, class: 'customize-dropdown-wrapper' do
        content_tag(:i, '', class: 'icon-help') +
        content_tag(:div, class: 'customize-dropdown') do
          content_tag(:b, 'Free customisation') +
          tag(:br) +
          "You can customise almost any aspect of this dress. Contact us today to enquire about customising this dress."
        end
      end
      mail + dropdown
    end
  end

  def in_wishlist?(variant)
    return current_wished_product_ids.include?(variant.product_id)
  end

  def share_buttons(product = nil)
    return '' if Rails.env.development?
    render 'shared/share_buttons', product: product
  end

  def send_to_a_friend_link(product)
    #return '' unless Rails.env.development?

    data = { product: product.permalink }
    data.update({ guest: true }) unless spree_user_signed_in?

    link_to 'Show mum', '#', class: 'send-to-friend askmumbtn', data: data, title: 'Send this dress to whoever you want to get a second opinion from!'
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
      link_to content_tag(:i, '', class: 'icon icon-heart') + 'Move to wish list', '#', data: { id: variant.id }, class: 'move-to-wishlist'
    else
      link_to content_tag(:i, '', class: 'icon icon-heart') + 'Move to wish list', spree_signup_path
    end
  end

  # 'product reservation' link or 'twin alert'
  def product_twin_alert_link(product)
    return '' if product.blank?

    if signed_in? && (reservation = spree_current_user.reservation_for(product)).present?
      raw("<div class='reserved'><i class='icon icon-tick-circle'></i> #{spree_current_user.first_name}, you have reserved this dress in #{reservation.color}.</div>")
    else
      data_attrs = { id: product.id }
      if signed_in? && previous_reservation = spree_current_user.reservations.last
        data_attrs.update(
          school_name: previous_reservation.school_name,
          formal_name: previous_reservation.formal_name,
          school_year: previous_reservation.school_year
        )
      end
      content_tag(:div, class: 'twin-alert') do
        link_to("Twin Alert", '#', class: 'twin-alert-link btn black', data: data_attrs) +
        content_tag(:div, "Make sure you dont buy the same dress as someone else. First choose a colour above.", class: 'twin-alert-info')
      end
    end
  end

  def activity_description(activity, user)
    if activity.info[:school_name]
      actor_description = "Someone from #{activity.info[:school_name]}"
    elsif (actor = activity.actor).present?
      actor_description = actor.first_name
    else
      actor_description = "Someone"
    end

    action_description, action_class = case activity.action
    when "purchased"
      [ "purchased this item", "icon-purchase" ]
    when "added_to_cart"
      [ "added this item to their cart", "icon-bag" ]
    when "added_to_wishlist"
      [ "added this item to their wishlist", "icon-heart" ]
    else # when 'viewed' & by default
      [ "viewed this item", "icon-eye" ]
    end

    raw("#{content_tag(:i, '', class: 'icon ' + action_class)} #{actor_description} #{action_description} #{timeago(activity.updated_at)}")
  end

  def timeago(time, options = {})
    options[:class] ||= "timeago"
    content_tag(:abbr, time.to_s, options.merge(:title => time.getutc.iso8601)) if time
  end
end
