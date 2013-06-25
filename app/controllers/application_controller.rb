class ApplicationController < ActionController::Base
  protect_from_forgery

  private

  def step1_custom_dresses_path(options = {})
    super options.merge(user_addition_params)
  end

  def step2_custom_dress_path(object, options = {})
    super object, options.merge(user_addition_params)
  end

  def success_custom_dress_path(object, options = {})
    super object, options.merge(user_addition_params)
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
    if session[:sign_up_reason]
      case session[:sign_up_reason]
        when 'custom_dress' then
          'Custom dress'
      end
    end
  end
end
