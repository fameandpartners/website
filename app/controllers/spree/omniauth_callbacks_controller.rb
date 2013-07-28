class Spree::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  include Spree::Core::ControllerHelpers::Common
  include Spree::Core::ControllerHelpers::Order
  include Spree::Core::ControllerHelpers::Auth

  def self.provides_callback_for(*providers)
    providers.each do |provider|
      class_eval %Q{
        def #{provider}
          if request.env["omniauth.error"].present?
            flash[:error] = t("devise.omniauth_callbacks.failure", :kind => auth_hash['provider'], :reason => t(:user_was_not_valid))
            redirect_back_or_default(root_url)
            return
          end

          authentication = Spree::UserAuthentication.find_by_provider_and_uid(auth_hash['provider'], auth_hash['uid'])

          if authentication.present?
            flash[:notice] = "Signed in successfully"
            sign_in :spree_user, authentication.user

            if session.delete(:sign_up_reason).eql?('custom_dress')
              session[:spree_user_return_to] = main_app.step1_custom_dresses_path(user_addition_params)
            end

            redirect_to after_sign_in_path_for(authentication.user)
          elsif spree_current_user
            spree_current_user.apply_omniauth(auth_hash)
            spree_current_user.save!
            flash[:notice] = "Authentication successful."
            redirect_back_or_default(account_url)
          else
            user = Spree::User.find_by_email(auth_hash['info']['email']) || Spree::User.new
            user.apply_omniauth_with_additional_attributes(auth_hash)

            if user.new_record?
              custom_fields = {
                :Signupreason => sign_up_reason_for_campaign_monitor,
                :Signupdate => Date.today.to_s
              }

              user.sign_up_via = Spree::User::SIGN_UP_VIA.index('Facebook')
              user.sign_up_reason = session[:sign_up_reason]
            end

            user.confirm!

            if user.save
              CampaignMonitor.delay.synchronize(user.email, user, custom_fields)
              flash[:notice] = "Signed in successfully."

              sign_in :spree_user, user

              if session.delete(:sign_up_reason).eql?('custom_dress')
                session[:spree_user_return_to] = main_app.step1_custom_dresses_path(user_addition_params)
              end

              redirect_to after_sign_in_path_for(user)
            else
              session[:omniauth] = auth_hash.except('extra')
              flash[:notice] = t(:one_more_step, :kind => auth_hash['provider'].capitalize)
              redirect_to new_user_registration_url
            end
          end

          if current_order
            user = spree_current_user || authentication.user
            current_order.associate_user!(user)
            session[:guest_token] = nil
          end
        end
      }
    end
  end

  SpreeSocial::OAUTH_PROVIDERS.each do |provider|
    provides_callback_for provider[1].to_sym
  end

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
end
