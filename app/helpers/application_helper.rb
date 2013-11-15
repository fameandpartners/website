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
    "#{controller.controller_name} #{restfull_action_name}"
  end

  def controller_action_id
    "#{controller.controller_name}"
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

  def collection_product_path(product, options = {})
    taxon = range_taxon_for(product)
    if taxon
      taxon_permalink = taxon.permalink.split('/').last
      build_collection_product_path(taxon_permalink, product.to_param, options)
    else
      spree.product_path(product, options)
    end
  end

  def collection_product_url(product, options)
    url_without_double_slashes(root_url(site_version: nil) + collection_product_path(product, options))
  end

  # custom_collection_product_url('Long-Dresses', 'the-fallen', cf: 'homefeature')
  # "http://www.fameandpartners.com/collection/Long-Dresses/the-fallen?cf=homefeature" 
  def build_collection_product_path(collection_id, product_id, options = {})
    site_version_prefix = self.url_options[:site_version]
    if site_version_prefix.present?
      path = "/#{site_version_prefix}/collection/#{collection_id}/#{product_id}"
    else
      path = "/collection/#{collection_id}/#{product_id}"
    end
    path = "#{path}?#{options.to_param}" if options.present?
    url_without_double_slashes(path)
  end

  def build_collection_product_url(collection_id, product_id, options = {})
    url_without_double_slashes(
      root_url(site_version: nil) + build_collection_product_path(collection_id, product_id, options)
    )
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
    if protocol.blank?
      protocol = request.protocol
    end
    "#{protocol}://#{request.host_with_port}#{image_url}"
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

  def newsletter_modal_popup
    if !spree_user_signed_in? && cookies[:newsletter_mp] != 'hide'
      render 'shared/newsletter_modal_popup'
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
      image_tag("https://www.paypal.com/en_US/i/btn/btn_xpressCheckout.gif"),
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
  # order purchased   - 6009784531696
  def fb_analytics_track(pixel_id, currency = 'AUD', value = '0.00')
    render 'spree/shared/facebook_analytics', {
      pixel_id: pixel_id,
      currency: currency,
      value: value
    }
  end

  def price_for_product(product)
    price = product.zone_price_for(current_site_version)
    if product.in_sale?
      [
        content_tag(:del, price.display_price_without_discount),
        content_tag(:span, price.display_price_with_discount)
      ].join("\n").html_safe
    else
      content_tag(:span, price.display_price).html_safe
    end
  end

  def price_for_line_item(line_item)
    if line_item.in_sale?
      [
        content_tag(:del, line_item.money_without_discount),
        content_tag(:span, line_item.money)
      ].join("\n").html_safe
    else
      content_tag(:span, line_item.money).html_safe
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
    name.push(current_site_version.code) if name.is_a?(Array)
    name[:site_version] = current_site_version.code if name.is_a?(Hash)

    super(name, options, &block)
  end

  private

  def current_sale
    @current_sale ||= Spree::Sale.first_or_initialize
  end
end
