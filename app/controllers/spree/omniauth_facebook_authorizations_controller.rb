class Spree::OmniauthFacebookAuthorizationsController < Spree::StoreController
  #layout 'spree/layouts/spree_application'
  respond_to :html

  # store params in session and redirects through omniauth_callbacks#through
  def fb_auth
    if params[:prom]
      session[:spree_user_return_to] = main_app.step1_custom_dresses_path
    elsif params[:quiz]
      session[:show_quiz] = true
    elsif params[:competition]
      session[:spree_user_return_to] = main_app.enter_competition_path(competition_id: Competition.current)
      session[:invite] = params[:invite]
      session[:competition] = params[:competition]
    elsif params[:personalization]
      session[:spree_user_return_to] = main_app.personalization_products_path(cf: 'custom-dresses-signup')
    elsif params[:return_to] && params[:return_to] == 'checkout'
      session[:spree_user_return_to] = spree.checkout_path
    elsif params[:bridesmaid_party]
      session[:spree_user_return_to] = main_app.bridesmaid_party_info_path
    end

    if session[:sign_up_reason].blank?
      if params[:prom]
        session[:sign_up_reason] = 'custom_dress'
      elsif params[:quiz]
        session[:sign_up_reason] = 'style_quiz'
      elsif params[:competition]
        session[:sign_up_reason] = 'competition'
      elsif params[:personalization]
        session[:sign_up_reason] = 'customise_dress'
      elsif params[:bridesmaid_party]
        session[:sign_up_reason] = 'bridesmaid_party'

        if session[:bridesmaid_party_event_id]
          event = BridesmaidParty::Event.find(session[:bridesmaid_party_event_id])
          session[:spree_user_return_to] = main_app.bridesmaid_party_moodboard_path(
            user_slug: event.spree_user.slug
          )
          session[:show_successfull_login_popup] = true
        end
      end
    end

    redirect_to spree.spree_user_omniauth_authorize_url(provider: :facebook, scope: 'email,public_profile,user_friends')
  end

  # can be used by application_controller filters to set proper redirects
  def url_with_correct_site_version
    main_app.url_for(params.merge(site_version: current_site_version.code))
  end
end
