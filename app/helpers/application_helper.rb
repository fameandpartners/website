# encoding: utf-8
module ApplicationHelper
  def conditional_html(options = {}, &block)
    lang = I18n.locale
    html_class = options[:class]
    html = <<-"HTML".gsub( /^\s+/, '' )
      <!--[if lt IE 7 ]>    <html lang="#{lang}" class="#{lang} #{html_class} ie ie6 no-js"> <![endif]-->
      <!--[if IE 7 ]>       <html lang="#{lang}" class="#{lang} #{html_class} ie ie7 no-js"> <![endif]-->
      <!--[if IE 8 ]>       <html lang="#{lang}" class="#{lang} #{html_class} ie ie8 no-js"> <![endif]-->
      <!--[if IE 9 ]>       <html lang="#{lang}" class="#{lang} #{html_class} ie ie9 no-js"> <![endif]-->
      <!--[if (gte IE 9)|!(IE)]><!--> <html xmlns:fb="http://ogp.me/ns/fb#" lang="#{lang}" class="#{lang} #{html_class} no-js"> <!--<![endif]-->
    HTML
    html += capture( &block ) << "\n</html>".html_safe if block_given?
    html.html_safe
  end


  def hreflang_tag

    hreflang_language = get_hreflang_code

    hreflang_link = get_hreflang_link

    r = "<link href='#{hreflang_link}' hreflang='#{hreflang_language}' rel='alternate' />"

    r.html_safe
  end

  def get_hreflang_link
    
    hreflang_language = get_hreflang_code
    current_language = get_current_language_code

    if request.fullpath.include? "/au"
      hreflang_link = "http://#{request.host}#{request.fullpath}"
      hreflang_link.gsub!('/au', '')
    else
      # united states is default, so default hreflang should be australian
      hreflang_link = "http://#{request.host}/au#{request.fullpath}"
      hreflang_link.gsub!('/us', '')
    end

    hreflang_link
  end

  def get_hreflang_code
    if current_site_version.is_australia?
      hreflang_language = 'en-us'
    else
      hreflang_language = 'en-au'
    end

    return hreflang_language
  end

  def get_current_language_code
    if current_site_version.is_australia?
      current_language = 'au'
    else
      current_language = 'us'
    end

    return current_language
  end

  def restfull_action_name
    case controller.action_name.to_sym
    when :create
      'new'
    when :update
      'edit'
    else
      controller.action_name
    end
  end

  def short_post_body(post)
    simple_body = simple_format(post.try(:body))
    if simple_body.present?
      lines = simple_body.lines.to_a[0..1]
      if lines[0].size < 100
        joined_lines = lines.join('')
        if joined_lines.size < 100
          "#{joined_lines[0..100]}..."
        else
          joined_lines
        end
      else
        "#{lines[0][0..100]}..."
      end
    end
  end

  def show_breadcrumbs
    @breadcrumbs.map do |breadcrumb|
      link_to breadcrumb.last, breadcrumb.first
    end.join(' » ')
  end

  def red_carpet_posts_page?
    params[:controller] == 'blog/posts' && params[:type] == 'red_carpet' &&
    (params[:action] == 'show' || params[:action] == 'index')
  end

  def simple_posts_page?
    params[:controller] == 'blog/posts' && params[:type].blank? &&
    (params[:action] == 'show' || params[:action] == 'index')
  end

  def celebrities_page?
    params[:controller] == 'blog/celebrities' && (params[:action] == 'show' || params[:action] == 'index')
  end

  def authors_page?
    params[:controller] == 'blog/authors'
  end

  def request_path?(path)
    request.path =~ Regexp.new(Regexp.escape(path))
  end

  def controller_action_class
    name = controller.controller_name.to_s.downcase
    path = controller.controller_path.gsub(/\W+/, '_')
    "#{name} #{path} #{restfull_action_name}"
  end

  def controller_action_id
    @controller_action_id || "#{controller.controller_name}"
  end

  def facebook_authentication_available?
    facebook_application.present?
  end

  def facebook_application
    Spree::AuthenticationMethod.where(environment: ::Rails.env, provider: :facebook, active: true).first
  end

  def make_url prefix, text
    "/#{prefix.join('/')}/#{text.downcase.gsub(/\s/, "_")}"
  end

  def total_cart_items
    if current_order
      current_order.line_items.inject(0){|total, line_item| total += line_item.quantity}
    else
      0
    end
  end

  def with_required_mark(text)
    raw (text + content_tag(:span, ' * ', class: 'required'))
  end

  # don't touch http:// or ftp://
  def url_without_double_slashes(url)
    # search elements with not colons and replace inside them
    url.gsub(/\w+(\/\/)/){|a| a.sub('//', '/')}
  end

  def collection_taxon_path(taxon)
    if range_taxonomy && range_taxonomy.taxons.where(id: taxon.id).exists?
      permalink = taxon.permalink.split('/').last
      site_version_prefix = self.url_options[:site_version]
      if site_version_prefix.present?
        "/#{site_version_prefix}/collection/#{permalink}".gsub(/\/+/, '/')
      else
        "/collection/#{permalink}"
      end
    else
      collection_path
    end
  end

  def descriptive_url(product, locale = nil)
    parts = []
    # this was how we had translated short descriptions as a part of the url
    # let's not delete it just yet, we might have to bring it back from the dead once again :)
    #parts << product.translated_short_description(locale || I18n.locale).parameterize
    parts << product.name.parameterize
    parts << product.id

    

    parts.reject(&:blank?).join('-')
  end

  def collection_product_path(product, options = {})
    site_version_prefix = self.url_options[:site_version]
    path_parts = [site_version_prefix, 'dresses']
    locale = I18n.locale.to_s.downcase.underscore.to_sym

    if product.is_a?(Tire::Results::Item) && product[:urls][locale].present?
      path_parts << "dress-#{product[:urls][locale]}"
    else
      path_parts << "dress-#{descriptive_url(product, locale)}"
    end

    path =  "/" + path_parts.compact.join('/')
    path = "#{path}?#{options.to_param}" if options.present?
    
    url_without_double_slashes(path)
  end

  def colored_variant_path(variant, options = {})
    
    parts = []
    parts << self.url_options[:site_version]
    parts << 'dresses'
   
    parts << "dress-#{variant.product[:urls][I18n.locale.to_s.downcase.underscore.to_sym]}"
    parts << variant.color.name

    path =  '/' + parts.reject(&:blank?).join('/')
    path = "#{path}?#{options.to_param}" if options.present?

    url_without_double_slashes(path)
  end

  def personalize_path(product, options={})
    site_version_prefix = self.url_options[:site_version]
    path_parts = [site_version_prefix, 'dresses', "custom-#{descriptive_url(product)}" ]
    path =  "/" + path_parts.compact.join('/')
    path = "#{path}?#{options.to_param}" if options.present?    
    
    url_without_double_slashes(path)
  end

  def style_it_path(product, options={})
    site_version_prefix = self.url_options[:site_version]
    path_parts = [site_version_prefix, 'dresses', "styleit-#{descriptive_url(product)}" ]
    path =  "/" + path_parts.compact.join('/')
    path = "#{path}?#{options.to_param}" if options.present?    
    
    url_without_double_slashes(path)
  end

  def collection_product_url(product, options = {})
    url_without_double_slashes(root_url(site_version: nil) + collection_product_path(product, options))
  end

  def build_collection_taxon_path(collection, options = {})
    build_collection_product_path(collection, nil, options)
  end

  # custom_collection_product_url('Long-Dresses', 'the-fallen', cf: 'homefeature')
  # "http://www.fameandpartners.com/collection/Long-Dresses/the-fallen?cf=homefeature" 
  def build_collection_product_path(collection_id, product_id, options = {})
    site_version_prefix = self.url_options[:site_version]
    path_parts = [site_version_prefix, 'collection', collection_id, product_id]
    path = "/" + path_parts.compact.join('/')
    path = "#{path}?#{options.to_param}" if options.present?

    url_without_double_slashes(path)
  end

  def build_collection_product_url(collection_id, product_id, options = {})
    url_without_double_slashes(
      root_url(site_version: nil) + build_collection_product_path(collection_id, product_id, options)
    )
  end


  def build_taxon_path(taxon_name, options={})
    site_version_prefix = self.url_options[:site_version]

    #must downcase because we want case insensitive urls
    taxon = Spree::Taxon.where('lower(name) =?', taxon_name.downcase).last

    

    if taxon.nil?
      #check for non-hyphenated version of the taxon name
      taxon = Spree::Taxon.where('lower(name) = ?', taxon_name.downcase.gsub('-', ' ')).last
    end

    taxon_name = taxon.name.parameterize unless taxon.nil?

    path_parts = [site_version_prefix, 'dresses',taxon_name]
    path = "/" + path_parts.compact.join('/')
    path = "#{path}?#{options.to_param}" if options.any?
    

    url_without_double_slashes(path)
  end

  def colour_path(color, options={})
    site_version_prefix = self.url_options[:site_version]
    path_parts = [site_version_prefix, 'dresses', color.downcase.parameterize]
    path = "/" + path_parts.compact.join('/')
    path = "#{path}?#{options.to_param}" if options.any?

    url_without_double_slashes(path)
  end


  def taxon_path(taxon)
    site_version_prefix = self.url_options[:site_version]

    if site_version_prefix.present?
      result = "/#{site_version_prefix}/#{taxon.permalink}"
    else
      result = "/#{taxon.permalink}"
    end

    result.gsub(/\/+/, '/')
  end

  def absolute_image_url(image_url, protocol = nil)
    parsed_url = URI.parse(image_url)
    parsed_url.scheme ||= (protocol.present? ? protocol : request.protocol )
    parsed_url.host ||= request.host
    parsed_url.path.to_s[/^\/?/] = '/' # prepend path with /
    parsed_url.port ||= request.port # uri parse set 80/443 if scheme exists
    parsed_url.to_s
  rescue
    image_url
  end

  def serialized_current_user
    if spree_user_signed_in?
      user = spree_current_user
      { fullname: user.fullname, email: user.email }
    else
      {}
    end
  end

  # move method calls to layout, if there will be too many places
  def thanks_popup_for_new_competition_entrant
    if session[:new_entrant] && params[:cf] == 'competition'
      session[:new_entrant] = false
      render 'competitions/thanks_popup'
    end
  end


  def paypal_payment_method
    @paypal_payment_method ||= Spree::PaymentMethod.where(
      type: "Spree::Gateway::PayPalExpress",
      environment: Rails.env,
      active: true,
      deleted_at: nil
    ).first
  end

  def paypal_available?
    paypal_payment_method.present?
  end

  def paypal_express_button
    return if paypal_payment_method.blank?

    url = paypal_express_url(payment_method_id: paypal_payment_method.id, protocol: request.protocol)
    link_to(
      image_tag('checkout/shopping_bag_paypal.png'),
      url, method: :post, id: "paypal_button"
    )
  end

  def guest_paypal_express_button
    return if paypal_payment_method.blank?

    url = guest_paypal_express_url(payment_method_id: paypal_payment_method.id, protocol: request.protocol)
    link_to(
      image_tag("https://www.paypal.com/en_US/i/btn/btn_xpressCheckout.gif"),
      url, method: :post, id: "paypal_button"
    )
  end

  # competition share - 6009830748096
  # order purchased   - 6013645244896
  def fb_analytics_track(pixel_id, currency = 'AUD', value = '0.00')
    render 'spree/shared/facebook_analytics', {
      pixel_id: pixel_id,
      currency: currency,
      value: value
    }
  end

  # individual product discount
  # sale discount
  # promocode discount
  # note - fixed 
  def product_discount(product)
    if product.discount.present?
      product.discount
    #elsif show_prices_with_applied_promocode?
    #  current_promotion.calculate_price_with_discount(variant.price).display_price
    else
      nil
    end
  end

  # price: amount, currency, display_price
  # discount: amount
  def product_price_with_discount(price, discount)
    if discount.blank? || discount.amount.to_i == 0
      price.display_price.to_s.html_safe
    else
      # add fixed price amount calculations
      amount_with_discount = price.amount * (100 - discount.amount.to_i) / 100
      sale_price = Spree::Price.new(amount: amount_with_discount, currency: price.currency)
      [
        content_tag(:span, price.display_price, class: 'price-old'),
        sale_price.display_price.to_s
      ].join("\n").html_safe
    end
  end

  # span.price-old $355
  # ' $295
  def price_for_product(product)
    price = product.zone_price_for(current_site_version)
    same_price = false
    
    if show_prices_with_applied_promocode? || product.in_sale?
      same_price = price.display_price == current_promotion.calculate_price_with_discount(price).display_price
    end

    if show_prices_with_applied_promocode? && !same_price
      [
        content_tag(:span, price.display_price, class: 'price-old'),
        current_promotion.calculate_price_with_discount(price).display_price
      ].join("\n").html_safe
    elsif product.in_sale? && !same_price
      [
        content_tag(:span, price.display_price_without_discount, class: 'price-old'),
        price.display_price_with_discount(is_surryhills?(product)).to_s
      ].join("\n").html_safe
    else
      price.display_price.to_s.html_safe
    end
  end

  def price_for_line_item(line_item)
    if line_item.in_sale?
      [
        content_tag(:span, line_item.money_without_discount, class: 'price-old'),
        line_item.money
      ].join("\n").html_safe
    else
      line_item.money.to_s.html_safe
    end
  end

  def sale_active?
    current_sale.active?
  end

  def dynamic_colors
    type = Spree::OptionType.where(name: 'dress-color').first
    return [] unless type
    values_table = Arel::Table.new(:spree_option_values)
    type.option_values.
      where(values_table[:value].not_eq(nil).and(values_table[:value].not_eq('')))
  end

  def cache(name = {}, options = nil, &block)
    if name.is_a?(Array)
      name.push(current_site_version.code)
      name.compact!
    elsif name.is_a?(Hash)
      name[:site_version] = current_site_version.code
    end

    super(name, options, &block)
  end

  def personalised_store_available?
    spree_user_signed_in? && current_spree_user.style_profile.try(:active?)
  end

  def soundcloud_widget(song_id = nil)
    return '' if song_id.nil?

    player_url_options = {
      color: 'ff6600',
      auto_play: false,
      show_artwork: true,
      url: "https://api.soundcloud.com/tracks/#{ song_id }"
    }
    media_player_url = "https://w.soundcloud.com/player/?#{ player_url_options.to_query }"
    iframe_options = { width: "100%", height: '166', scrolling: 'no', frameborder: 'no' }
    content_tag(:iframe, '', iframe_options.merge(src: media_player_url))
  end

  def get_products_from_edit (edit, currency, user, count=9)
    searcher = Products::ProductsFilter.new(:edits => edit)
    searcher.current_user = user
    searcher.current_currency = currency
    return searcher.products.first(count)
  end

  def current_sale
    @current_sale ||= Spree::Sale.first_or_initialize
  end

  def is_surryhills?(product)
    if product.property('factory_name').present? && (product.property('factory_name').downcase == "surryhills" || product.property('factory_name').downcase == "iconic")
      return true 
    else
      return false
    end
  end
end
