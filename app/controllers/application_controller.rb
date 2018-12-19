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

  append_before_filter :handle_marketing_campaigns

  before_filter :website_on_maintenance, if: proc { Features.active?(:maintenance) }
  before_filter :add_debugging_information
  before_filter :set_locale
  before_filter :set_landing_page

  helper_method :landing_page,
                :contentful_global_page_config

  def handle_marketing_campaigns
    referrer = params[:referrer] || request.referrer
    cookies[:referrer] = referrer if cookies[:referrer].blank?

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

    Raven.user_context email: current_spree_user.try(:email), id: current_spree_user.try(:id)
    Raven.extra_context order_id: current_order.try(:id), order_number: current_order.try(:number)
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

  def default_locale
    'en-US'
  end

  def set_locale
    session[:locale] = I18n.locale = current_site_version.try(:locale) || default_locale
  end

  def website_on_maintenance
    render 'index/maintenance', layout: 'redesign/maintenance'
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

  def set_landing_page
    session[:landing_page] ||= request.path
  end

end
