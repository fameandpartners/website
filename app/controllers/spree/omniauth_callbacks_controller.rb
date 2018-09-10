# coding: utf-8
class Spree::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  include Spree::Core::ControllerHelpers::Common
  include Spree::Core::ControllerHelpers::Order
  include Spree::Core::ControllerHelpers::Auth

#  # this provides default providers details.
#  SpreeSocial::OAUTH_PROVIDERS.each do |provider|
#    provides_callback_for provider[1].to_sym
#  end

  def track_new_modal_fb
    return unless session[:new_modal_fb_state] == 'clicked'
    session[:new_modal_fb_state]  = 'signed_in'
    session[:ty_heading]          = 'Thanks! Did you know our dresses are made <br> bespoke by artisan seamstresses?'
    session[:ty_message]          = 'This means we can give you a bunch of perks that others simply can’t:'
    session[:ty]                  = 'Thanks'
  end

  def mark_and_track_promo_redemption(email)
    return unless session[:redeem_via_fb_state] == 'clicked'
    session[:redeem_via_fb_state] = 'signed_in'
    track_new_modal_fb
    event_type = 'email_capture_modal'
    event_type = 'auto_apply_coupon' if session[:auto_apply].present?

    begin
      tracker = Marketing::CustomerIOEventTracker.new
      unless current_spree_user
        tracker.identify_user_by_email(email, current_site_version)
      end
      tracker.track(
        current_spree_user || email,
        event_type,
        email:            email,
        promocode:        session[:show_promocode_modal] || session[:auto_apply_promo]
      )
    rescue StandardError => e
      Rails.logger.error('[customer.io] Failed to send event: #{event_type}')
      Rails.logger.error(e)
      NewRelic::Agent.notice_error(e)
    end
  end

  def return_to_mb_page
    session[:spree_user_return_to] = "/moodboards"
    session[:nonlogin_go_to_mb_page] = nil
  end
  
  def facebook
    if request.env["omniauth.error"].present?
      flash[:error] = t("devise.omniauth_callbacks.failure", :kind => auth_hash['provider'], :reason => t(:user_was_not_valid))
      redirect_back_or_default(root_url)
      return
    end

    authentication = Spree::UserAuthentication.find_by_provider_and_uid(auth_hash['provider'], auth_hash['uid'])

    if authentication.present?
      flash[:notice] = "Signed in successfully"
      flash[:track_fb_signin] = "true"
      sign_in :spree_user, authentication.user

      FacebookDataFetchWorker.perform_async(authentication.user.id, auth_hash['uid'], auth_hash['credentials']['token'])

      mark_and_track_promo_redemption(authentication.user.email)
      return_to_mb_page if session[:nonlogin_go_to_mb_page]
      redirect_to after_sign_in_path_for(authentication.user), flash: { just_signed_up: true }
    elsif spree_current_user
      spree_current_user.apply_omniauth(auth_hash)
      spree_current_user.save

      FacebookDataFetchWorker.perform_async(spree_current_user.id, auth_hash['uid'], auth_hash['credentials']['token'])

      flash[:notice] = "Authentication successful."
      flash[:track_fb_signup] = "true"
      mark_and_track_promo_redemption(spree_current_user.email)
      redirect_back_or_default(account_url)
    else
      user = Spree::User.find_by_email(auth_hash['info']['email']) || Spree::User.new

      unless user.respond_to? :apply_omniauth_with_additional_attributes
        load 'lib/overrides/spree_social/user_decorator.rb'
      end

      user.apply_omniauth_with_additional_attributes(auth_hash)

      if user.new_record?
        user.sign_up_via = Spree::User::SIGN_UP_VIA.index('Facebook')
        user.sign_up_reason = session[:sign_up_reason]
      end

      if user.save
        flash[:notice] = "Signed in successfully."

        FacebookDataFetchWorker.perform_async(user.id, auth_hash['uid'], auth_hash['credentials']['token'])

        sign_in :spree_user, user

        sign_up_reason = session.delete(:sign_up_reason)

        mark_and_track_promo_redemption(user.email)
        return_to_mb_page if session[:nonlogin_go_to_mb_page]
        redirect_to after_sign_in_path_for(user), flash: { just_signed_up: true }
      else
        session[:omniauth] = auth_hash.except('extra')
        flash[:notice] = t(:one_more_step, :kind => auth_hash['provider'].capitalize)
        redirect_to main_app.new_spree_user_registration_url
      end
    end

    user ||= (spree_current_user || authentication.try(:user))
    user.generate_spree_api_key!

    EmailCapture.new({},
                     email: user.email,
                     newsletter: user.newsletter,
                     first_name: user.first_name,
                     last_name: user.last_name,
                     current_sign_in_ip: request.remote_ip,
                     landing_page: session[:landing_page],
                     utm_params: session[:utm_params],
                     site_version: current_site_version.name,
                     form_name: 'create_account').capture
    
    if session[:email_reminder_promo].present? && session[:email_reminder_promo] !=  'scheduled_for_delivery'
      tracker = Marketing::CustomerIOEventTracker.new
      tracker.identify_user(user, current_site_version)
      tracker.track(
        user,
        'email_reminder_promo',
        promo: session[:email_reminder_promo]
      )
      session[:email_reminder_promo] = 'scheduled_for_delivery'
      flash[:track_fb_reminder_promo] = "true"
    end

    if current_order
      current_order.associate_user!(user) if user.present?
      session[:guest_token] = nil
    end
  end

  def failure
    set_flash_message :alert, :failure, :kind => failed_strategy.name.to_s.humanize, :reason => failure_message
    redirect_to spree.login_path
  end

  def passthru
    raise ActiveRecord::RecordNotFound
  end

  def auth_hash
    request.env["omniauth.auth"]
  end

  def after_omniauth_failure_path_for(scope)
    new_spree_user_session_path()
  end
end
