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
      <!--[if (gte IE 9)|!(IE)]><!--> <html prefix="fb: http://ogp.me/ns/fb#" lang="#{lang}" class="#{lang} #{html_class} no-js"> <!--<![endif]-->
    HTML
    html += capture( &block ) << "\n</html>".html_safe if block_given?
    html.html_safe
  end

  # TODO: This method will have to change when multiple locales support comes
  def get_hreflang_link
    if request.fullpath.include? "/au"
      hreflang_link = request.fullpath.gsub('/au', '')
    else
      # united states is default, so default hreflang should be australian
      hreflang_link = request.fullpath.gsub('/us', '')
    end

    hreflang_link
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
    @facebook_application ||= begin
      Spree::AuthenticationMethod.where(environment: ::Rails.env, provider: :facebook, active: true).first
    end
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
    if product.present? && (discount = product.discount).present?
      discount
    # elsif show_prices_with_applied_promocode?
    #  current_promotion.discount
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
      # NOTE - we should add fixed price amount calculations
      sale_price = price.apply(discount)
      [
        content_tag(:span, price.display_price, class: 'price-original'),
        content_tag(:span, sale_price.display_price.to_s, class: 'price-sale'),
        content_tag(:span, "Save #{discount.amount}%", class: 'price-discount'),
      ].join("\n").html_safe
    end
  end



  # span.price-old $355
  # ' $295
  def price_for_product(product)
    price = product.zone_price_for(current_site_version)
    discount = product_discount(product)
    product_price_with_discount(price, discount)
  end
=begin

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
=end

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
    current_sale.present? && current_sale.active?
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
    @current_sale ||= Spree::Sale.where(sitewide: true).first
  end

  def is_surryhills?(product)
    if product.property('factory_name').present? && (product.property('factory_name').downcase == "surryhills" || product.property('factory_name').downcase == "iconic")
      return true
    else
      return false
    end
  end

  def bootstrap_class_for(flash_type)
    { success: "alert-success", error: "alert-danger", alert: "alert-warning", notice: "alert-info" }[flash_type] || flash_type.to_s
  end

end
