class ApplicationController < ActionController::Base
  protect_from_forgery

  include Errors::Sentry::ControllerConcern

  include Spree::Core::ControllerHelpers::Order
  include Spree::Core::ControllerHelpers::Auth
  include Spree::Core::ControllerHelpers::Common
  include ApplicationHelper
  include PathBuildersHelper
  include Concerns::SiteVersion
  include Concerns::UserCampaignable
  include Concerns::AutomaticDiscount
  include Concerns::Moodboards
  include Concerns::Errors
  include Concerns::Webpack

  # Marketing related concerns
  include Marketing::Gtm::Controller::Container
  include Marketing::Tracking::Cookie

  if Features.active?(:force_sitewide_ssl)
    ssl_required
  end

  append_before_filter :store_marketing_params
  append_before_filter :check_marketing_traffic
  append_before_filter :count_competition_participants, if: proc { |_| params[:cpt].present? }
  append_before_filter :handle_marketing_campaigns

  before_filter :website_on_maintenance, if: proc { Features.active?(:maintenance) }
  before_filter :set_session_country
  before_filter :add_debugging_information
  before_filter :set_locale
  before_filter :set_landing_page

  helper_method :analytics_label,
                :current_wished_product_ids,
                :default_meta_description,
                :default_seo_title,
                :get_user_type,
                :serialize_user,
                :serialized_current_user,
                :landing_page,
                :webpack_assets

  def count_competition_participants
    cpt = params[:cpt]
    session[:cpts] ||= []

    return if session[:cpts].include?(cpt)

    participation = CompetitionParticipation.find_by_token(cpt)

    return if participation.blank?
    return if participation.spree_user.eql?(try_spree_current_user)

    session[:cpts] << cpt
    participation.increment!(:views_count)
  end

  def handle_marketing_campaigns
    referrer = params[:referrer] || request.referrer
    cookies[:referrer] = referrer if cookies[:referrer].blank?

    # TODO - TTL 2016.01.30 - Shopstyle missing promocode
    # Handle inbound shopstyle campaigns with a missing auto apply promo code.
    # Apply the missing code
    if !request.url.include?('faadc') && (referrer && referrer.include?('shopstyle.com'))
      uri = Addressable::URI.parse(request.url)
      uri.query_values = (uri.query_values || {}).merge(:faadc => 'BOXINGDAY25')
      redirect_to uri.to_s
    end
    # END Shopstyle missing promocode

    if params[:utm_campaign].present?
      capture_user_utm_params
      capture_order_utm_params
    end

    if cookies[:utm_guest_token].present? && current_spree_user.present?
      associate_user_by_utm_guest_token
    end
  end

  def capture_user_utm_params
    referrer = params[:referrer] || request.referrer

    utm_params = {
      utm_campaign:   params[:utm_campaign],
      utm_source:     params[:utm_source],
      utm_medium:     params[:utm_medium],
      utm_term:       params[:utm_term],
      utm_content:    params[:utm_content],
    }

    service = Marketing::CaptureUtmParams.new(
      current_spree_user,
      cookies['utm_guest_token'],
      utm_params.merge(referrer: referrer)
    )
    service.record_visit!
    session[:utm_params] = utm_params

    if service.user_token_created?
      cookies.permanent[:utm_guest_token] = service.user_token
    end
  end

  def capture_order_utm_params
    if current_order
      utm_params = {
        utm_medium: params[:utm_medium],
        utm_source: params[:utm_source],
        utm_campaign: params[:utm_campaign]
      }
      if current_order.traffic_parameters
        current_order.traffic_parameters.update_attributes(utm_params)
      else
        current_order.create_traffic_parameters(utm_params)
      end
    end
  end

  # it's shame to add such method to filter
  # but we don't have 'after-sign-in' callback or single entry point for user log-in
  def associate_user_by_utm_guest_token
    if current_spree_user.present? && cookies[:utm_guest_token].present?
      Marketing::UserVisits.associate_with_user_by_token(
        user: current_spree_user, token: cookies[:utm_guest_token]
      )
      cookies.delete(:utm_guest_token)
    end
  end

  def add_debugging_information
    ::NewRelic::Agent.add_custom_attributes({
      user_id:      current_spree_user.try(:id),
      user_email:   current_spree_user.try(:email),
      order_id:     current_order.try(:id),
      order_number: current_order.try(:number),
      referrer:     request.referrer
    })
  rescue Exception => _
    true
  end

  def landing_page
    session[:landing_page]
  end

  private

  def title(*args)
    @title = args.flatten.delete_if(&:blank?).join(' | ')
  end

  def description(*args)
    @description = args.flatten.delete_if(&:blank?).join(' | ')
  end

  def default_seo_title
    Preferences::SEO.new(current_site_version).default_seo_title
  end

  def default_meta_description
    Preferences::SEO.new(current_site_version).default_meta_description
  end

  def get_user_type
    spree_user_signed_in? ? 'Member' : 'Guest'
  end

  def analytics_label(label_type, *args)
    case label_type.to_sym
    when :product
      product = args.first
      "#{product.name} - #{product.sku} - #{product.price.to_s} - #{get_user_type}"
    when :user_cart_product
      product = args.first
      "#{product[:name]} - #{product[:sku]} - #{product[:price][:display_price]} - #{get_user_type}"
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

  def current_wished_product_ids
    if @current_wished_product_ids
      @current_wished_product_ids
    else
      user = try_spree_current_user
      @current_wished_product_ids = user.present? ? user.wishlist_items.map(&:spree_product_id) : []
    end
  end

  def serialized_current_user
    if spree_user_signed_in?
      serialize_user(spree_current_user)
    else
      {}
    end
  end

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

  def set_product_show_page_title(product, info = "")
    prefix = "#{product.short_description} #{info} #{product.name}"
    self.title = [prefix, default_seo_title].join(' - ')
    description([prefix, default_meta_description].join(' - '))
  end

  def default_locale
    'en-US'
  end

  def set_locale
    session[:locale] = I18n.locale = current_site_version.try(:locale) || default_locale
  end

  # todo: remove this method from global scope
  def get_recommended_products(product, options = {})
    Products::RecommendedProducts.new(product: product, limit: options[:limit]).read
  rescue
    Spree::Product.active.limit(3)
  end

  def website_on_maintenance
    render 'index/maintenance', layout: 'redesign/maintenance'
  end

  def store_marketing_params
    # seems parameter not using anywhere else
    #if params[:dmb].present?
    #  cookies[:dmb] = { value: params[:dmb], expires: 1.day.from_now }
    #  cookies[:dmb_time] = { value: Time.now.to_s, expires: 1.day.from_now }
    #end
    if params[:promocode].present?
      cookies[:promocode] = { value: params[:promocode], expires: 1.day.from_now }
    end
  end

  # if user comes via marketing then dont pop stye quiz
  def check_marketing_traffic
    if (params[:utm_campaign].present? || params[:gclid].present?) && cookies[:quiz_shown].blank?
      cookies[:quiz_shown] = true
    end
  end

  def display_marketing_banner
    @display_marketing_banner = true
  end

  # this logic should be placed in separate module
  # somewhere in app/controllers/concerns/returnable
  def is_user_came_from_current_app
    return false if request.referrer.blank?
    URI.parse(request.referrer).host == request.host
  rescue Exception => _
    # built-in ruby uri known for parse/generate issues.
    false
  end

  def set_after_sign_in_location(location, options = {})
    return if location && location.match(/\b(login|logout|fb_auth|session|sign_in|sign_out)\b/)
    session[:user_return_to] = location
    session[:spree_user_return_to] = location
  end

  def after_sign_in_path_for(resource)
     session[:user_return_to] || session[:spree_user_return_to] || request.env['omniauth.origin'] || root_path
  end

  def set_session_country
    session[:country_code] ||= FindCountryFromIP.new(request.remote_ip).country_code
  end

  def set_landing_page
    session[:landing_page] ||= request.path
  end

end
