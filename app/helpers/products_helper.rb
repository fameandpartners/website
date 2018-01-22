module ProductsHelper
  def range_taxonomy
    @range_taxonomy ||= Spree::Taxonomy.where(name: 'Range').first
  end

  def range_taxon_for(product)
    return nil if range_taxonomy.blank?
    taxon = product.taxons.first
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

  def available_product_events
    range_taxonomy = Spree::Taxonomy.where(name: 'Event').first

    if range_taxonomy.present?
      return range_taxonomy.root.children
    else
      return []
    end
  end

  def available_product_styles
    range_taxonomy = Spree::Taxonomy.where(name: 'Style').first
    range_taxonomy.present? ? range_taxonomy.root.children : []
  end

  def available_product_colors
    color_option = Spree::Variant.color_option_type
    color_option.present? ? color_option.option_values : []
  end

  def fabric_swatch_colors
    Rails.cache.fetch('fabric_swatches_heavy') do
      prd = Spree::Product.find_by_name('Fabric Swatch - Heavy Georgette')

      prd.variants.map do |swatch_variant|
        {
          variant_id: swatch_variant.id,
          product_id: swatch_variant.product.id,
          sku: swatch_variant.sku,
          color_name: swatch_variant.dress_color.presentation,
          color_id: swatch_variant.dress_color.id,
          color_hex: swatch_variant.dress_color.value,
          price: swatch_variant.prices.first.amount
        }
      end
    end
  end

  # Temporarily allow order of otherwise unavailable garments
  def custom_order?
    params[:custom_order] == '2015-09' || params[:custom_order] == '2015-10'
  end

  def seo_taxonomy
    @seo_taxonomy ||= Spree::Taxonomy.where("lower(name) = ?", 'SeoCollection'.downcase).first
  end

  def available_seo_taxonomy_urls
    seo_taxonomy.present? ? seo_taxonomy.root.children : []
  end

  def hoverable_image_tag(sources = [], options = {})
    blank   = 'assets/noimage/product.png'
    sources = Array(sources)

    if sources.empty?
      image_tag(blank, options)
    else
      if sources.size > 1
        options[:original_image] = sources.first
        options[:second_image]   = sources.second
      end
      options[:onerror] = "window.switchToAltImage(this, '#{blank}')"

      image_tag sources.first, options
    end
  end

  def hoverable_product_image_tag(product, options = {})
    colors = options.delete(:colors)

    images = if product.images.empty?
      []
    else
      if colors.present?
        images_for_colors = product.images_for_colors(colors).limit(2).to_a

        if images_for_colors.present?
          images_for_colors
        else
          product.images
        end
      else
        product.images
      end
    end

    if images.blank? || images.first.alt.blank?
      alt = product.name
    else
      alt = images.first.alt
    end

    options.reverse_merge! :alt => alt

    sources = images.map{ |image| image.attachment.url(:large) }

    hoverable_image_tag(sources, options)
  end

  # Used to hack around issues with campaign images and product images for AMFAM
  def amfam_hoverable_product_image_tag(product, options = {})
    colors = options.delete(:colors)

    images = if product.images.empty?
      []
    else
      if colors.present?
        images_for_colors = product.images_for_colors(colors).limit(2).to_a

        if images_for_colors.present?
          [images_for_colors.last, images_for_colors.first]
        else
          [product.images.last, product.images.first]
        end
      else
        [product.images.last, product.images.first]
      end
    end

    if images.blank? || images.last.alt.blank?
      alt = product.name
    else
      alt = images.last.alt
    end

    options.reverse_merge! :alt => alt

    sources = images.map{ |image| image.attachment.url(:large) }

    hoverable_image_tag(sources, options)
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

  # Used to hack around issues with campaign images and product images for AMFAM
  def product_last_image_tag(product, size = nil, options = {})
    no_image = 'noimage/product.png'
    size = size.present? ? size : 'large'

    options[:title] ||= product.name

    if product.images.empty?
      image_tag(no_image, options)
    else
      image = product.images.last
      options.reverse_merge! alt: image.alt.blank? ? product.name : image.alt

      image_tag(image.attachment.url(size), options)
    end
  end

  def line_item_image_url(line_item, size = :small)
    image = line_item.image
    if image.present? && image.attachment.present?
      image.attachment.url(size)
    else
      'noimage/product.png'
    end
  end

  # old, not cacheable variant
  def add_to_wishlist_link(product_or_variant, options = {})
    options[:title] ||= 'Moodboard'
    options[:class] ||= ''
    options[:class] += ' add-wishlist'

    if spree_user_signed_in?
      variant = product_or_variant.is_a?(Spree::Product) ? product_or_variant.master : product_or_variant

      link_options = {
        data: {
          'title-add'     => options[:title],
          'title-remove'  => 'Remove from moodboard',
          'action'        => 'add-to-wishlist',
          'product-id'    => variant.product_id,
          'id'            => variant.id
        },
        class: options[:class]
      }

      if in_wishlist?(variant)
        link_options[:class] += ' active'
        link_to 'Remove from moodboard', '#', link_options
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
  def cached_add_to_wishlist_link(resource, options = {})
    color_id   = options.delete(:color_id)

    if resource.is_a?(Spree::Variant)
      variant_id = resource.id
      product_id = resource.product_id
      color_id   ||= resource.dress_color.try(:id)
    elsif resource.is_a?(Spree::Product)
      variant_id = resource.master.id
      product_id = resource.id
    else
      variant_id = resource.master_id
      product_id = resource.id
    end

    title = options.delete(:title) || 'Add to moodboard'
    title_remove = options.delete(:title_remove) || 'Remove from moodboard'
    link_class = options.delete(:class)
    link_class = link_class.to_s + ' add-wishlist'

    data_args = {
      'title-add'     => title,
      'title-remove'  => title_remove,
      'action'        => 'add-to-wishlist',
      'product-id'    => product_id,
      'color-id'      => color_id,
      'id'            => variant_id
    }

    link_to title, spree_signup_path, class: link_class, data: data_args
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

=begin
  def product_move_to_wishlist_link(variant, options = {})
    size = options[:size] ||= ''

    if spree_user_signed_in?
      link_to '+ move to moodboard', '#', data: { id: variant.id }, class: "move-to-wishlist btn #{size} empty border"
    else
      link_to '+ move to moodboard', spree_signup_path, class: "btn #{size} empty border"
    end
  end
=end

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

  def color_options_for_select(color_names, selected_color_name)
    color_option_values = Spree::OptionValue.colors.where(name: color_names)
    color_options_for_select_from_options_values(color_option_values, selected_color_name)
  end

  def color_options_for_select_from_options_values(color_option_values, selected = nil)
    options = color_option_values.sort_by{ |c| c.name.downcase }.map do |option_value|
      [
        option_value.presentation,
        option_value.name,
        class: "color #{option_value.name}"
      ]
     end

    options_for_select(options, selected)
  end

  def is_directed_from?(path)
    Regexp.new(path, true) =~ request.env['HTTP_REFERER']
  end

  def breadcrumbs_for(product)
    items = []

    if is_directed_from?(my_boutique_path)
      items << link_to('My Boutique', my_boutique_path)
    else
      items << link_to('Dresses', collection_path)
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

  def new_this_week_products
    return [] if Rails.env.test?

    Rails.cache.fetch(['new_this_week_products', current_site_version.code], expire_in: configatron.cache.expire.long) {
      Products::CollectionResource.new({ edits: 'new-this-week', site_version: current_site_version }).read.serialize[:products]
    }
  end
end
