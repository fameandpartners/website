class ApplicationController < ActionController::Base
  protect_from_forgery

  include Spree::Core::ControllerHelpers::Order
  include Spree::Core::ControllerHelpers::Auth
  include Spree::Core::ControllerHelpers::Common
  include ApplicationHelper
  include PathBuildersHelper

  append_before_filter :check_site_version
  append_before_filter :check_cart
  append_before_filter :add_site_version_to_mailer
  #append_before_filter :get_visitor_info
  append_before_filter :count_competition_participants,     if: proc {|c| params[:cpt].present? }
  append_before_filter :capture_utm_params,                 if: proc {|c| params[:utm_campaign].present? }
  append_before_filter :associate_user_by_utm_guest_token,  if: proc {|c| cookies[:utm_guest_token].present? }

  before_filter :add_debugging_infomation
  before_filter :try_reveal_guest_activity # note - we should join this with associate_user_by_utm_guest_token
  before_filter :set_locale

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

  def check_site_version
    # redirects should work only on non-ajax GET requests from users
    return if (!request.get? || request.xhr? || request_from_bot?)

    store_marketing_params
    check_marketing_traffic

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

  def capture_utm_params
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
      utm_params.merge(referrer: request.referrer)
    )
    service.record_visit!

    if service.user_token_created?
      cookies.permanent[:utm_guest_token] = service.user_token
    end
  end

  # it's shame to add such method to filter
  # but we don't have 'after-sign-in' callback or single entry point for user log-in
  def associate_user_by_utm_guest_token
    if current_spree_user.present? && cookies[:utm_guest_token].present?
      Marketing::UserVisits.asssociate_with_user_by_token(
        user: current_spree_user, token: cookies[:utm_guest_token]
      )
      cookies.delete(:utm_guest_token)
    end
  end

  def add_debugging_infomation
    ::NewRelic::Agent.add_custom_parameters({
      user_id: current_spree_user.try(:id),
      order_id: current_order.try(:id)
    })
  rescue Exception => e
    true
  end

=begin
  # NOTE: girlfriends popups seems disabled for now
  def get_visitor_info
    #if session[:user_info] == nil
      host = request.referrer
      in_referrer = false
      in_campaign = false
      in_source = false

      if !host.blank?
        in_referrer = host
        cookies[:referrer] = host
      end

      if params[:utm_campaign].present?
        in_campaign = params[:utm_campaign]
        cookies[:utm_campaign] = params[:utm_campaign]
      end
      
      if params[:utm_source].present?
        in_source = cookies[:utm_source]
        cookies[:utm_source] = params[:utm_source]
      end

      session[:user_info] = true

      check_if_girlfriend(in_referrer, in_campaign, in_source)
    #else
    #  return
    #end
  end 

  def check_if_girlfriend(in_referrer, in_campaign, in_source)
    return if cookies[:gf_pop].present?

    referrer = in_referrer.match(/girlfriend|girlfriendmagazine/) unless in_referrer.blank?
    campaign = in_campaign.match(/girlfriend|gfxfp/) unless in_campaign.blank?
    source = in_source.match(/gf/) unless in_source.blank?
  
    if referrer || campaign || source
      cookies[:gf_campaign] = 'true'
      unless cookies[:gf_pop] == 'hide'
        cookies[:gf_pop] = 'show'
      end
    else
      return
    end
  end
=end

  # default version. overrided in spree based controllers
  # ATTENTION!
  # are you thinking that this method below is called from the check_site_verision (the one somewhere above) ?
  # well it isn't k? Why? I have no idea.
  # go to base_controller_decorator for the method that actually gets called and save yourself a couple of hours :)
  def url_with_correct_site_version
    #main_app.url_for(params.merge(site_version: current_site_version.code))
    if request.fullpath.include?("/au/") or request.fullpath.include?("/us/")
      path = request.fullpath.gsub(/^\/../, '')
    else
      path =  request.fullpath
    end

    '/' + current_site_version.code + path + "?"
  end

  def store_current_location
    session[:previous_location] = get_hreflang_link # url_with_correct_site_version
  end

  def previous_location_or_default(default_url, previous_location = nil)
    if previous_location
      previous_location
    elsif session[:previous_location].present?
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

  helper_method :default_seo_title, :default_meta_description

  helper_method :analytics_label, :get_user_type

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
      "- Fame & Partners"
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

#  def current_spree_user
#    @current_spree_user ||= super && Spree::User.includes(:wishlist_items).find(@current_spree_user.id)
#  end
  def current_spree_user
    super
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
    prefix = "#{product.short_description} #{info} #{product.name}"
    self.title = [prefix, default_seo_title].join(' - ')
    description([prefix, default_meta_description].join(' - '))

#    range_taxonomy ||= Spree::Taxonomy.where(name: 'Range').first

#    if range_taxonomy.present? && range_taxon = @product.taxons.where(taxonomy_id: range_taxonomy.id).first
#      prefix = "#{product.short_description} #{info} #{@product.name} in #{range_taxon.name}"
#      self.title = [prefix, default_seo_title].join(' - ')
#     description([prefix, default_meta_description].join(' - '))
#    end
  end

  helper_method :current_site_version, :site_versions_enabled?

  def site_versions_enabled?
    @site_versions_enabled ||= (SiteVersion.count > 1)
  end

  def current_site_version
    @current_site_version ||= begin
      service = FindUsersSiteVersion.new(
        user: current_spree_user,
        url_param: params[:site_version],
        cookie_param: cookies[:site_version],
        request_ip: request.remote_ip
      )
      service.get().tap do |site_version|
        cookies[:site_version]  ||= site_version.code
        cookies[:ip_address]    ||= request.remote_ip
        if current_spree_user && current_spree_user.site_version_id != site_version.id
          current_spree_user.update_column(:site_version_id, site_version.id)
        end
      end
    end
  end

  def current_site_version=(site_version)
    @current_site_version = site_version
  end

  def request_from_bot?
    user_agent = request.env["HTTP_USER_AGENT"]
    #user_agent =~ /(bot|Google|Slurp)/i
    user_agent =~ /(Baidu|bot|Google|Facebook|SiteUptime|Slurp|WordPress|ZIBB|ZyBorg)/i
  end

  def current_currency
    current_site_version.try(:currency) || Spree::Config[:currency]
  end

  def default_locale
    'en-US'
  end

  def set_locale
    session[:locale] = I18n.locale = current_site_version.try(:locale) || default_locale
  end

  def current_user_moodboard
    @user_moodboard ||= UserMoodboard::BaseResource.new(user: current_spree_user).read
  end
  helper_method :current_user_moodboard

  # todo: remove this method from global scope
  def get_recommended_products(product, options = {})
    Products::RecommendedProducts.new(product: product, limit: options[:limit]).read
  rescue
    Spree::Product.active.limit(3)
  end

  def store_marketing_params
    if params[:dmb].present?
      cookies[:dmb] = { value: params[:dmb], expires: 1.day.from_now }
      cookies[:dmb_time] = { value: Time.now.to_s, expires: 1.day.from_now }
    end
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

  def current_promotion
    @current_promotion ||= begin
      code = params[:promocode] || cookies[:promocode]
      code.present? ? Spree::Promotion.find_by_code(code) : nil
    end
  end
  helper_method :current_promotion

  def display_marketing_banner
    @display_marketing_banner = true
  end
end
