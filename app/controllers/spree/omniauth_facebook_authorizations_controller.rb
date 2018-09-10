class Spree::OmniauthFacebookAuthorizationsController < Spree::StoreController
  #layout 'spree/layouts/spree_application'
  respond_to :html

  # store params in session and redirects through omniauth_callbacks#through
  def fb_auth
    session[:sign_up_reason] = nil

    if params[:return_to]
      set_after_sign_in_location(params[:return_to])
    elsif params[:spree_user_return_to]
      set_after_sign_in_location(params[:spree_user_return_to])
    elsif is_user_came_from_current_app
      set_after_sign_in_location(request.referrer)
    end

    if params[:redeem_via_fb_state]
      session[:redeem_via_fb_state] = params[:redeem_via_fb_state]
    end

    if params[:new_modal_fb_state]
      session[:new_modal_fb_state] = params[:new_modal_fb_state]
    end

    if params[:show_promocode_modal]
      session[:show_promocode_modal] = params[:show_promocode_modal]
      # reset current modal popup
      set_after_sign_in_location(root_path)
    end

    session[:auto_apply]           = params[:auto_apply] if params.key?(:auto_apply)
    session[:auto_apply_promo]     = params[:auto_apply_promo] if params.key?(:auto_apply_promo)

    # Capture PLEASE REMIND ME ABOUT MY SALE events to push onto customer.io later.
    session[:email_reminder_promo] = params[:email_reminder_promo] if params.key?(:email_reminder_promo)


    redirect_to spree.spree_user_omniauth_authorize_url(provider: :facebook, scope: 'email,first_name,last_name,user_friends')
  end

  # can be used by application_controller filters to set proper redirects
  def url_with_correct_site_version
    main_app.url_for(params.merge(site_version: current_site_version.code))
  end
end
