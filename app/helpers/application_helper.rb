# encoding: utf-8
module ApplicationHelper
  include Split::Helper # Split testing

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

  # individual product discount
  # sale discount
  # promocode discount
  # note - fixed
  def product_discount(product)
    if product.present? && (discount = product.discount).present?
      discount
    else
      nil
    end
  end

  # price: amount, currency, display_price
  # discount: amount
  def product_price_with_discount(price, discount)
    if (discount.blank? || discount.amount.to_i == 0)
      price.display_price.to_s.html_safe
    else
      # NOTE - we should add fixed price amount calculations
      if discount.present?
        sale_price = price.apply(discount)
      end

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
    price = product.site_price_for(current_site_version)
    discount = product_discount(product)
    product_price_with_discount(price, discount)
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
    return unless current_sale.present?
    sale_promo? || current_sale.active?
  end

  def display_sale_notice?
    sale_active? && current_sale.sitewide_message.present?
  end

  def sale_path
    if sale_promo?
      dresses_path(:faadc => current_sale.sale_promo)
    else
      dresses_path
    end
  end

  def sale_promo?
    current_sale.present? && current_sale.sale_promo.present?
  end

  def dynamic_colors
    type = Spree::OptionType.color
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

  def get_products_from_edit(edit, currency, user, count=9)
    searcher = Products::ProductsFilter.new(:edits => edit, per_page: count)
    searcher.current_user = user
    searcher.current_currency = currency

    # This is faster than doing all the N+1 query stuff that happens in the views.
    Spree::Product.hydrated_from_ids(searcher.products.collect(&:id))
  end

  def current_sale
    @current_sale ||= Spree::Sale.where(sitewide: true).first
  end

  def bootstrap_class_for(flash_type)
    { success: "alert-success", error: "alert-danger", alert: "alert-warning", notice: "alert-info" }[flash_type] || flash_type.to_s
  end

end
