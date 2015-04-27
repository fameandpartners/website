class Spree::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  include Spree::Core::ControllerHelpers::Common
  include Spree::Core::ControllerHelpers::Order
  include Spree::Core::ControllerHelpers::Auth

  def facebook
    if request.env["omniauth.error"].present?
      flash[:error] = t("devise.omniauth_callbacks.failure", :kind => auth_hash['provider'], :reason => t(:user_was_not_valid))
      redirect_back_or_default(root_url)
      return
    end

    authentication = Spree::UserAuthentication.find_by_provider_and_uid(auth_hash['provider'], auth_hash['uid'])

    if authentication.present?
      flash[:notice] = "Signed in successfully"
      sign_in :spree_user, authentication.user

      FacebookDataFetchWorker.perform_async(authentication.user.id, auth_hash['uid'], auth_hash['credentials']['token'])

      sign_up_reason = session.delete(:sign_up_reason)
      if sign_up_reason.eql?('custom_dress')
        session[:spree_user_return_to] = main_app.step1_custom_dresses_path(user_addition_params)
      elsif sign_up_reason.eql?('competition')
        session[:spree_user_return_to] = main_app.enter_competition_path(competition_id: Competition.current)
      elsif sign_up_reason.eql?('bridesmaid_party')
        try_apply_bridesmaid_party_callback(authentication.user)
      end

      redirect_to after_sign_in_path_for(authentication.user), flash: { just_signed_up: true }
    elsif spree_current_user
      spree_current_user.apply_omniauth(auth_hash)
      spree_current_user.save

      FacebookDataFetchWorker.perform_async(spree_current_user.id, auth_hash['uid'], auth_hash['credentials']['token'])

      if session[:sign_up_reason].eql?('bridesmaid_party')
        try_apply_bridesmaid_party_callback(spree_current_user)
      end

      flash[:notice] = "Authentication successful."
      redirect_back_or_default(account_url)
    else
      user = Spree::User.find_by_email(auth_hash['info']['email']) || Spree::User.new
      user.apply_omniauth_with_additional_attributes(auth_hash)

      if user.new_record?
        user.sign_up_via = Spree::User::SIGN_UP_VIA.index('Facebook')
        user.sign_up_reason = session[:sign_up_reason]

        if session[:sign_up_reason].eql?('competition')
          session[:spree_user_return_to] = main_app.enter_competition_path(competition_id: Competition.current)
        else
          session[:spree_user_return_to] = main_app.root_path(:cf => :signup)
        end
      end

      if user.save
        flash[:notice] = "Signed in successfully."

        FacebookDataFetchWorker.perform_async(user.id, auth_hash['uid'], auth_hash['credentials']['token'])

        sign_in :spree_user, user

        sign_up_reason = session.delete(:sign_up_reason)
        if sign_up_reason.eql?('custom_dress')
          session[:spree_user_return_to] = main_app.step1_custom_dresses_path(user_addition_params)
        elsif sign_up_reason.eql?('competition')
          session[:spree_user_return_to] = main_app.enter_competition_path(competition_id: Competition.current)
        elsif sign_up_reason.eql?('customise_dress')
          session[:spree_user_return_to] = main_app.personalization_products_path(cf: 'custom-dresses-signup')
        elsif sign_up_reason.eql?('bridesmaid_party')
          try_apply_bridesmaid_party_callback(user)
        end

        redirect_to after_sign_in_path_for(user), flash: { just_signed_up: true }
      else
        session[:omniauth] = auth_hash.except('extra')
        flash[:notice] = t(:one_more_step, :kind => auth_hash['provider'].capitalize)
        redirect_to main_app.new_spree_user_registration_url
      end
    end

    if current_order
      user ||= (spree_current_user || authentication.try(:user))
      current_order.associate_user!(user) if user.present?
      session[:guest_token] = nil
    end
  end

  #SpreeSocial::OAUTH_PROVIDERS.each do |provider|
  #   provides_callback_for provider[1].to_sym
  #end

  def failure
    set_flash_message :alert, :failure, :kind => failed_strategy.name.to_s.humanize, :reason => failure_message
    redirect_to spree.login_path
  end

  def passthru
    render :file => "#{Rails.root}/public/404", :formats => [:html], :status => 404, :layout => false
  end

  def auth_hash
    request.env["omniauth.auth"]
  end

  private

  def try_apply_bridesmaid_party_callback(user)
    if session[:bridesmaid_party_membership_id]
      membership = BridesmaidParty::Member.find(session[:bridesmaid_party_membership_id])
      if membership
        membership.update_column(:spree_user_id, user.id)
        session[:spree_user_return_to] = main_app.bridesmaid_party_moodboard_path(user_slug: membership.event.spree_user.slug)
      end
    else
      session[:spree_user_return_to] = main_app.bridesmaid_party_info_path
    end
  end
end
