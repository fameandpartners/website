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

  def with_required_mark(text)
    raw (text + content_tag(:span, ' * ', class: 'required'))
  end

  def collection_taxon_path(taxon)
    if range_taxonomy && range_taxonomy.taxons.where(id: taxon.id).exists?
      permalink = taxon.permalink.split('/').last
      "/collection/#{permalink}"
    else
      collection_path
    end
  end

  def collection_product_path(product)
    taxon = range_taxon_for(product)
    if taxon
      permalink = taxon.permalink.split('/').last
      "/collection/#{permalink}/#{product.to_param}"
    else
      spree.product_path(product)
    end
  end

  def collection_product_url(product)
    root_url + collection_product_path(product)
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
end
