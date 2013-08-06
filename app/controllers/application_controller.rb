class ApplicationController < ActionController::Base
  protect_from_forgery

  include Spree::Core::ControllerHelpers::Order
  include Spree::Core::ControllerHelpers::Auth

  append_before_filter :check_cart

  def check_cart
    # if can't find order, create it ( true )
    current_order(true) if current_order.blank?
  end

  helper_method :default_seo_title, :default_meta_description

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
    if session[:sign_up_reason]
      case session[:sign_up_reason]
        when 'custom_dress' then
          'Custom dress'
        when 'style_quiz' then
          'Style quiz'
        when 'workshop' then
          'Workshop'
      end
    end
  end
end
