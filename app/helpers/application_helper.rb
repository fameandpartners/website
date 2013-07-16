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
      <!--[if (gte IE 9)|!(IE)]><!--> <html lang="#{lang}" class="#{lang} #{html_class} no-js"> <!--<![endif]-->
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

  def controller_action_class
    "#{controller.controller_name} #{restfull_action_name}"
  end

  def controller_action_id
    "#{controller.controller_name}"
  end

  def facebook_authentication_available?
    Spree::AuthenticationMethod.exists?(:environment => ::Rails.env, :provider => :facebook, :active => true)
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
end
