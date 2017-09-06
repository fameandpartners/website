module Api
  module V1
    class UserSessionsController < ApplicationController #< Devise::SessionsController
      include SslRequirement
      helper 'spree/users', 'spree/base'
      include Spree::Core::ControllerHelpers::Auth
      # include Spree::Core::ControllerHelpers::Common
      # include Spree::Core::ControllerHelpers::Order

      ssl_required :new, :create, :destroy

      respond_to :json
      skip_before_filter :verify_authenticity_token

      def create
        ensure_params_exist
        # authenticate_spree_user!

        resource = Spree::User.find_for_database_authentication(:login => params["spree_user"]["email"])
        return invalid_login_attempt unless resource

        if resource.valid_password?(params["spree_user"]["password"])
          sign_in("spree_user", resource)
          respond_with resource
          return
        end

        invalid_login_attempt
      end

      def destroy
        session.clear
        render :json => {:success=>true}, status: 200
      end

      private

      def ensure_params_exist
        return unless params[:spree_user].blank?
        render :json=>{:success=>false, :message=>"missing user_login parameter"}, :status=>422
      end

      def invalid_login_attempt
        warden.custom_failure!
        render :json=> {:success=>false, :message=>"Error with your login or password"}, :status=>401
      end

    end


  end
end
