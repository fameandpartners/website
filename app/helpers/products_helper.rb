module ProductsHelper

  def range_taxonomy
    @range_taxonomy ||= Spree::Taxonomy.where(name: 'Range').first
  end

  def range_taxon_for(product)
    return nil if range_taxonomy.blank?
    taxon = product.taxons.where(taxonomy_id: range_taxonomy.id).first
  end

  def range_taxon_name_for(product)
    taxon = range_taxon_for(product)
    if taxon.present?
      taxon.name.upcase
    else
      'LONG DRESSES' 
    end
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
    escaped_text = ActionView::Base.full_sanitizer.sanitize(description_text)
    truncate(escaped_text, length: 80, separator: ' ')
  rescue
    t('product_has_no_description')
  end

  def product_video(product, options = {})
    #return '' if Rails.env.development?
    return '' if product.video_url.blank?

    width   = options[:width] || 300
    height  = options[:height] || 533

    "<iframe width='#{width}' height='#{height}' src='#{product.video_url}' frameborder='0' allowfullscreen></iframe>"
  end

  def embed_video_player(video_url, options = {})
    width   = options[:width] || 300
    height  = options[:height] || 533

    "<iframe width='#{width}' height='#{height}' src='#{video_url}' frameborder='0' allowfullscreen></iframe>"
  end

  def hoverable_product_image_tag(product, options = {})
    no_image = 'noimage/product.png'
    colors = options.delete(:colors)

    if product.images.empty?
      image_tag(no_image, options)
    else
      images = if colors.present?
        images_for_colors = product.images_for_colors(colors).limit(2).to_a

        if images_for_colors.present?
          images_for_colors
        else
          product.images
        end
      else
        product.images
      end

      image = images.first
      options.reverse_merge! :alt => image.alt.blank? ? product.name : image.alt
      if images.size > 1
        # original_image - quick fix for cdn & and empty attr['src']
        options[:original_image]  = image.attachment.url(:large)
        options[:second_image]    = images.second.attachment.url(:large)
      end
      options[:onerror] = "window.switchToAltImage(this, '/assets/#{no_image}')"
      image_tag(image.attachment.url(:large), options)
    end
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


  def line_item_image_url(line_item, size = :small)
    image = line_item.image
    if image.present? && image.attachment.present?
      image.attachment.url(size, protocol_relative: true)
    else
      'noimage/product.png'
    end
  end

  def quick_view_link(product)
    link_to 'Quick view', collection_product_path(product), data: { action: 'quick-view', id: product.permalink }
  end

=begin
  def add_to_bag_link(product_or_variant)
    if product_or_variant.is_a?(Spree::Product)
      # don't use master variant as default
      link_to 'Add to bag', '#', class: 'buy-now btn'
    else
      link_to 'Add to bag', '#', class: 'buy-now btn', data: { id: product_or_variant.id }
    end
  end
=end

  # old, not cacheable variant
  def add_to_wishlist_link(product_or_variant, options = {})
    options[:title] ||= 'Wish list'
    options[:class] ||= ''
    options[:class] += ' add-wishlist'

    if spree_user_signed_in?
      variant = product_or_variant.is_a?(Spree::Product) ? product_or_variant.master : product_or_variant

      link_options = {
        data: { 
          'title-add'     => options[:title],
          'title-remove'  => 'Remove from wishlist',
          'action'        => 'add-to-wishlist',
          'product-id'    => variant.product_id,
          'id'            => variant.id
        },
        class: options[:class]
      }

      if in_wishlist?(variant)
        link_options[:class] += ' active'
        link_to 'Remove from wishlist', '#', link_options
      else
        link_to options[:title], '#', link_options
      end
    else # user not logged in, wishlist unavailable
      link_to options[:title], spree_signup_path, class: options[:class], data: { action: 'auth-required' }
    end
  end

  # render just placeholder
  # add_to_wishlist_link(variant, 
  #      title: 'Add to wishlist',
  #      class: 'wishlist-link',
  #      title-remove: 'Remove from wishlist'
  def cached_add_to_wishlist_link(product_or_variant, options = {})
    variant = product_or_variant.is_a?(Spree::Product) ? product_or_variant.master : product_or_variant

    title = options.delete(:title) || 'Add to wishlist'
    title_remove = options.delete(:title_remove) || 'Remove from wishlist'
    link_class = options.delete(:class)
    link_class = link_class.to_s + ' add-wishlist'

    link_to title, spree_signup_path, class: link_class, data: {
      'title-add'     => title,
      'title-remove'  => title_remove,
      'action'        => 'add-to-wishlist',
      'product-id'    => variant.product_id,
      'id'            => variant.id
    }
  end

  def in_wishlist?(variant)
    current_wished_product_ids.include?(variant.product_id)
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

  def send_to_a_friend_link(product)
    data = { product: product.permalink }
    data.update({ guest: true }) unless spree_user_signed_in?

    link_to 'Get a Second Opinion', '#', class: 'btn small send-to-friend', data: data, title: 'Send this dress to whoever you want to get a second opinion!'
  end

  def wishlist_move_to_cart_link(wishlist_item)
    variant = wishlist_item.variant
    if variant.is_master?
      data = {
        variant: variant.id,
        item: wishlist_item.id,
        quantity: wishlist_item.quantity
      }
      link_to 'Move to cart', '#', class: 'add-to-cart master btn mid fleft', data: data
    else
      url = move_to_cart_wishlists_item_path(wishlist_item)
      link_to 'Move to cart', url, class: 'add-to-cart btn mid fleft', remote: true
    end
  end

  def product_move_to_wishlist_link(variant, options = {})
    if spree_user_signed_in?
      link_to '+ move to wish list', '#', data: { id: variant.id }, class: 'move-to-wishlist btn empty border'
    else
      link_to '+ move to wish list', spree_signup_path, class: 'btn empty border'
    end
  end

=begin
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
        link_to("Twin Alert", '#', class: 'twin-alert-link btn', data: data_attrs) +
        content_tag(:div, t('views.pages.products.show.notices.twin_alert').html_safe, class: 'hint')
      end
    end
  end
=end

  def product_twin_alert_link(product)
    return '' if product.blank?

    if signed_in? && (reservation = spree_current_user.reservation_for(product)).present?
      content_tag(:div, class: 'twin-alert') do
        raw("<div class='reserved btn' title='#{spree_current_user.first_name}, you have reserved this dress in #{reservation.color}.'><i class='icon icon-tick-circle'></i> Reserved</div>")
      end
    else
      data_attrs = { product_id: product.id }

      content_tag(:div, class: 'twin-alert') do
        link_to("Reserve this Dress", '#', class: 'twin-alert-link btn', title: 'Reserve this dress for your event. Select a color first.', data: data_attrs)
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

  def color_options_for_select(color_names)
    color_option_values = Spree::OptionValue.colors.where(name: color_names)
    color_options_for_select_from_options_values(color_option_values)
  end

  def color_options_for_select_from_options_values(color_option_values, selected = nil)
    options_for_select(color_option_values.map do |option_value|
      [
        option_value.presentation, 
        option_value.name,
        class: "color #{option_value.name}"
      ]
    end, selected)
  end

  def is_directed_from?(path)
    Regexp.new(path, true) =~ request.env['HTTP_REFERER']
  end

  def breadcrumbs_for(product)
    items = []

    if is_directed_from?(my_boutique_path)
      items << link_to('My Boutique', my_boutique_path)
    else
      items << link_to('Collection', collection_path)
    end

    if (taxon = range_taxon_for(product)).present?
      items << link_to(taxon.name, "/#{taxon.permalink}")
    end

    items.join(' / ').html_safe
  end

  def collection_page_breadcrumb(searcher)
    items = []
    if searcher.collection.present?
      taxon = Spree::Taxon.find_by_id(searcher.collection.first)
      if taxon.present?
        items << taxon.name
      end
    end

    if items.present?
      items.unshift( link_to('Collection', collection_path, data: { action: 'show-collection' }))
      items.join(' / ').html_safe
    else
      ''
    end
  end


  # SIZES
  # Should be 0 2 4 6 8 10 12 14 16 18 20 22 24 26
  # AU should be 4 6 8 10 12 14 16 18 20 22 24 26
  # US should be 0 2 4 6 8 10 12 14 16 18 20 22
  # AU Plus Size should be 18 20 22 24 26
  # US Plus Size should be 14 16 18 20 22


  def locale_sizes(product, sizes)
    if current_site_version.is_australia?
      if is_plus_size?(product)
        return sizes && [18, 20, 22, 24, 26]
      else
        return sizes && [4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26]
      end
    else
      if is_plus_size?(product)
        return sizes && [14, 16, 18, 20, 22]
      else
        return sizes && [0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22]
      end
    end
  end

  def locale_size_attributes(size)
    if current_site_version.is_australia?
      SIZE_ATTRIBUTES.find_by_au_name(size.to_s)
    else
      SIZE_ATTRIBUTES.find_by_us_name(size.to_s)
    end
  end

  def locale_measurement_unit
    if current_site_version.is_australia?
      :cm
    else
      :in
    end
  end

  def dropdown_sizes(product, sizes)
    if sizes.size < 7
      return []
    else
      return sizes.from(6)
    end
  end

  def is_plus_size?(product)
    is_plus = product.taxons.where(:name =>"Plus Size").first
    return true if is_plus
  end
end
