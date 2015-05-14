class Spree::OmniauthFacebookAuthorizationsController < Spree::StoreController
  #layout 'spree/layouts/spree_application'
  respond_to :html

  # store params in session and redirects through omniauth_callbacks#through
  def fb_auth
    session[:sign_up_reason] = nil

    # code for bridesmaid party should be managed with bridesmaid-party module,
    # and don't pollute main app
    if params[:bridesmaid_party]
      session[:sign_up_reason] = 'bridesmaid_party'

      if session[:bridesmaid_party_event_id]
        event = BridesmaidParty::Event.find(session[:bridesmaid_party_event_id])
        set_after_sign_in_location(
          main_app.bridesmaid_party_moodboard_path( user_slug: event.spree_user.slug)
        )
        session[:show_successfull_login_popup] = true
      else
        set_after_sign_in_location(main_app.bridesmaid_party_info_path)
      end
    elsif params[:return_to]
      set_after_sign_in_location(params[:return_to])
    elsif params[:spree_user_return_to]
      set_after_sign_in_location(params[:spree_user_return_to])
    elsif is_user_came_from_current_app
      set_after_sign_in_location(request.referrer)
    end

    if params[:show_promocode_modal]
      session[:show_promocode_modal] = params[:show_promocode_modal]
      # reset current modal popup
      set_after_sign_in_location(root_path)
    end

    session[:auto_apply] = params[:auto_apply] if params.key?(:auto_apply)

    redirect_to spree.spree_user_omniauth_authorize_url(provider: :facebook, scope: 'email,public_profile,user_birthday,user_friends, user_events')
  end

  # can be used by application_controller filters to set proper redirects
  def url_with_correct_site_version
    main_app.url_for(params.merge(site_version: current_site_version.code))
  end
end
