class ApplicationController < ActionController::Base
  protect_from_forgery

  include Spree::Core::ControllerHelpers::Order
  include Spree::Core::ControllerHelpers::Auth
  include Spree::Core::ControllerHelpers::Common

  append_before_filter :check_site_version
  append_before_filter :check_cart
  append_before_filter :add_site_version_to_mailer

  def check_site_version
    # redirects should work only on non-ajax GET requests from users
    return if (!request.get? || request.xhr? || request_from_bot?)

    if params[:site_version].blank?
      if current_site_version.default?
        # do nothing
        store_current_location
      else
        redirect_to url_with_correct_site_version
      end
    else
      if params[:site_version] == current_site_version.code
        # do nothing
        store_current_location
      else params[:site_version] != current_site_version.code
        redirect_to url_with_correct_site_version
      end
    end
  end

  # default version. overrided in spree based controllers
  def url_with_correct_site_version
    main_app.url_for(params.merge(site_version: current_site_version.code))
  end

  def store_current_location
    session[:previous_location] = url_with_correct_site_version
  end

  def previous_location_or_default(default_url)
    if session[:previous_location].present?
      session[:previous_location]
    else
      default_url
    end
  end

  def check_cart
    # if can't find order, create it ( true )
    # current order calls current currency which calls current site version
    # and convert current order to current currency
    current_order(true) if current_order.blank?
    current_order.zone_id = current_site_version.zone_id
  end

  def add_site_version_to_mailer
    ActionMailer::Base.default_url_options.merge!(
      site_version: self.url_options[:site_version]
    )
  end

  def convert_current_order_prices
    if session[:order_id]
      order = Spree::Order.where(id: session[:order_id]).first
      if order.present? && !order.completed?
        order.use_prices_from(current_site_version)
      end
    end
  end

  helper_method :default_seo_title, :default_meta_description

  helper_method :analytics_label, :get_user_type

  before_filter :try_reveal_guest_activity

  before_filter :set_locale

  def url_options
    version = current_site_version

    if version.permalink.present? && version.permalink != 'us'
      site_version = version.permalink.html_safe
    else
      site_version = nil
    end

    result = { site_version: site_version }.merge(super)
    result.delete(:script_name)
    result
  end

  private

  def title(*args)
    @title = args.flatten.join(' | ')
  end

  def description(*args)
    @description = args.flatten.join(' | ')
  end

  def default_seo_title
    if Spree::Config[:default_seo_title].present? 
      Spree::Config[:default_seo_title]
    else
      "Fame & Partners - Dream Formal Dresses"
    end
  end

  def default_meta_description
    if Spree::Config[:default_meta_description].present?
      Spree::Config[:default_meta_description]
    else
      "Fame & Partners is committed to bringing the world of celebrity fashion to you. We offer our customers the opportunity to create a look that they love, that is unique to them and will ensure they feel like a celebrity on their special night."
    end
  end

  def get_user_type
    spree_user_signed_in? ? 'Member' : 'Guest'
  end

  def analytics_label(label_type, *args)
    case label_type.to_sym
    when :product
      product = args.first
      "#{product.name} - #{product.sku} - #{product.price.to_s} - #{get_user_type}"
    when :question
      question = args.first
      number = args.second
      "#{number} - #{question.text} - #{get_user_type}"
    when :search_query
      query = args.first
      "#{query} - #{get_user_type}"
    when :user
      get_user_type
    else
      args.join(' - ') || ''
    end
  rescue Exception => e
    return ''
  end

  def step1_custom_dresses_path(options = {})
    main_app.step1_custom_dresses_path(options.merge(user_addition_params))
  end

  def step2_custom_dress_path(object, options = {})
    main_app.step2_custom_dress_path(object, options.merge(user_addition_params))
  end

  def success_custom_dress_path(object, options = {})
    main_app.success_custom_dress_path(object, options.merge(user_addition_params))
  end

  helper_method :step1_custom_dresses_path,
                :step2_custom_dress_path,
                :success_custom_dress_path

  def user_addition_params
    addition_params = {}

    if spree_user_signed_in?
      addition_params[:user_id] = current_spree_user.id

      if current_spree_user.sign_up_via.present?
        addition_params[:sign_up_via] = Spree::User::SIGN_UP_VIA[current_spree_user.sign_up_via]
      end
    end

    addition_params
  end

  def sign_up_reason_for_campaign_monitor
    Spree::User.campaign_monitor_sign_up_reason(session['sign_up_reason'])
  end

  def current_spree_user
    @current_spree_user ||= super && Spree::User.includes(:wishlist_items).find(@current_spree_user.id)
  end

  def current_wished_product_ids
    if @current_wished_product_ids
      @current_wished_product_ids
    else
      user = try_spree_current_user
      @current_wished_product_ids = user.present? ? user.wishlist_items.map(&:spree_product_id) : []
    end
  end

  helper_method :current_wished_product_ids

  def serialized_current_user
    if spree_user_signed_in?
      serialize_user(spree_current_user)
    else
      {}
    end
  end

  helper_method :serialized_current_user, :serialize_user

  def serialize_user(user)
    {
      fullname: user.fullname,
      first_name: user.first_name,
      email: user.email,
      wish_list: serialize_wish_list(user)
    }
  end

  def serialize_wish_list(user)
    user.wishlist_items.map do |item|
      if item.spree_variant_id.present?
        { variant_id: item.spree_variant_id }
      else
        { product_id: item.spree_product_id }
      end
    end
  end

  def temporary_user_key
    if spree_user_signed_in?
      "user_#{try_spree_current_user.try(:id)}"
    else
      session[:temporary_user_key] ||= SecureRandom.hex(16)
    end
  end

  def try_reveal_guest_activity
    if spree_user_signed_in? && session[:temporary_user_key].present?
      Activity.replace_temporary_keys(session[:temporary_user_key], try_spree_current_user)
      session[:temporary_user_key] = nil
    end
  end

  def custom_dresses_path
    main_app.personalization_path
  end
  helper_method :custom_dresses_path

  def set_product_show_page_title(product, info = "")
    range_taxonomy ||= Spree::Taxonomy.where(name: 'Range').first

    if range_taxonomy.present? && range_taxon = @product.taxons.where(taxonomy_id: range_taxonomy.id).first
      prefix = " #{info} #{@product.name} in #{range_taxon.name}"
      self.title = [prefix, default_seo_title].join(' - ')
      description([prefix, default_meta_description].join(' - '))
    end
  end

  helper_method :current_site_version, :site_versions_enabled?

  def site_versions_enabled?
    @site_versions_enabled ||= (SiteVersion.count > 1)
  end

  def current_site_version
    @current_site_version ||= get_users_site_version
  end

  def get_users_site_version
    sv_choosen_by_user || sv_choosen_by_cookie || sv_choosen_by_location || sv_choosen_by_param || SiteVersion.default
  end

  def sv_choosen_by_user
    if user = try_spree_current_user
      if user.site_version_id.present? && site_version = SiteVersion.find_by_id(user.site_version_id)
        cookies[:site_version] = site_version.code # user site version with cookies version
        return site_version
      end
    end
  end

  def sv_choosen_by_cookie
    if cookies[:site_version].present?
      SiteVersion.find_by_permalink(cookies[:site_version])
    end
  end

  def sv_choosen_by_location
    version_permalink = fetch_user_country_code
    site_version = SiteVersion.find_by_permalink(version_permalink)
    if site_version.present?
      cookies[:site_version]  = site_version.code
      cookies[:ip_address]    = request.remote_ip
      return site_version
    else
      nil
    end
  end

  def sv_choosen_by_param
    SiteVersion.find_by_permalink(params[:site_version]) if params[:site_version].present?
  end

  def request_from_bot?
    user_agent = request.env["HTTP_USER_AGENT"]
    #user_agent =~ /(bot|Google|Slurp)/i
    user_agent =~ /(Baidu|bot|Google|SiteUptime|Slurp|WordPress|ZIBB|ZyBorg)/i
  end

  def current_site_version=(site_version)
    @current_site_version = site_version
  end
=begin
  # site_version : [us | au]
  # site_version_id : [1,2...]
  def current_site_version
    return @current_site_version if @current_site_version

    # instead of magic with before filters order...
    # otherwise, this will update session and we will lost first visit or not
    check_default_site_version

    if request.get?
      self.current_site_version = SiteVersion.by_permalink_or_default(params[:site_version])
    else
      # url without site_version, but we have version in session 
      if params[:site_version].blank? or params[:site_version].to_s != session[:site_version].to_s
        self.current_site_version = SiteVersion.by_permalink_or_default(session[:site_version])
      else
        self.current_site_version = SiteVersion.by_permalink_or_default(params[:site_version])
      end
    end
  end

  # * when visiting from AUS it is defaulting to USA, it should default to /au
  def first_visit?
    if params[:site_version].nil? && session[:site_version].nil? 
      return true if request.referrer.blank?
      host = URI.parse(request.referrer).host
      if host.match(/localhost|fameandpartners/)
        return false
      else
        return true
      end
    else
      return false
    end
  rescue Exception => e
    false
  end

  def check_default_site_version
    if first_visit?
      country_code = fetch_user_country_code
      self.current_site_version = SiteVersion.by_permalink_or_default(country_code)
      
      if country_code.eql?('au') && request.get?
        # when a new user goes to the homepage and gets redirected to AUS the /orders/populate url appears and is broken
        # detect if user wanted homepage if yes then redirect specifically to homepage
        redirect_url = params.merge(site_version: country_code)

        if params[:controller] == "index" && params[:action] == "show"
          redirect_url = root_path(params.except(:controller, :action).merge(site_version: country_code))
        end
        
        redirect_to url_for(redirect_url) and return
      end
    end
  end

  def current_site_version=(site_version)
    if session[:site_version] != site_version.permalink
      session[:site_version] = site_version.permalink
      @current_site_version = site_version

      if user = try_spree_current_user
        user.update_site_version(site_version)
      end

      convert_current_order_prices
    end

    site_version
  end
=end

  def current_currency
    current_site_version.try(:currency) || Spree::Config[:currency]
  end

  def fetch_user_country_code
    begin
      require 'geoip'
      geoip = GeoIP.new(File.join(Rails.root, 'db', 'GeoIP.dat'))
      remote_ip = request.remote_ip
      country_code = 'us'
      if remote_ip != "127.0.0.1"
        country_code = geoip.country(request.remote_ip).try(:country_code2)
      end

      country_code.downcase
    rescue Exception => exception
      Rails.logger.warn(exception.message)

      'us'
    end
  end

  def default_locale
    'en-US'
  end

  def set_locale
    session[:locale] = I18n.locale = current_site_version.try(:locale) || default_locale
  end

  def get_recommended_products(product, options = {})
    options[:limit] ||= 3
    recommended_dresses = []

    #if try_spree_current_user && try_spree_current_user.style_profile.present?
    #  recommended_dresses = Spree::Product.recommended_for(try_spree_current_user, options)
    #end
    #return recommended_dresses if (products_required = options[:limit] - recommended_dresses.to_a.length) <= 0
    recommended_dresses = SimilarProducts.new(product).fetch(products_required).to_a

    return recommended_dresses if (products_required = options[:limit] - recommended_dresses.to_a.length) <= 0
    recommended_dresses += Spree::Product.active.featured.limit(products_required).to_a

    return recommended_dresses if (products_required = options[:limit] - recommended_dresses.to_a.length) <= 0
    recommended_dresses + Spree::Product.active.limit(products_required).to_a
  rescue
    Spree::Product.active.limit(3)
  end

  def display_marketing_banner
    @display_marketing_banner = true
  end

end
