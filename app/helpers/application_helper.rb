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

  def with_required_mark(text)
    raw (text + content_tag(:span, ' * ', class: 'required'))
  end


  def price_for_line_item(line_item)
    if line_item.in_sale?
      [
        content_tag(:span, line_item.money_without_discount, class: 'price-old'),
        line_item.money
      ].join(r"\n").html_safe
    else
      line_item.money.to_s.html_safe
    end
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

  def current_sale
    @current_sale ||= Spree::Sale.last_sitewide_for(currency: current_site_version.currency)
  end

  def bootstrap_class_for(flash_type)
    flash_classes =  { success: 'alert-success', error: 'alert-danger', alert: 'alert-warning', notice: 'alert-info' }
    flash_classes.fetch(flash_type, flash_type.to_s)
  end

  def convert_height_units(height_value, height_unit)
    if ( !height_value || !height_unit)
      return nil
    end
    if (height_unit == 'inch')
      "#{height_value.to_i / 12}ft #{height_value.to_i % 12}in"
    else
      "#{height_value}cm"
    end
  end

  def height_title(personalization)
    personalization.nil? || personalization.height_value ? 'Height' : 'Skirt Length'
  end

  def display_height(height_value, height_unit, height)
    if height_value && height_unit
      convert_height_units(height_value, height_unit)
    else
      height
    end
  end

  def collection_url
    '/dresses'
  end

end
