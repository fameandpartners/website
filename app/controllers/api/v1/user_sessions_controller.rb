module Api
  module V1
    class UserSessionsController < Devise::SessionsController
      include SslRequirement
      helper 'spree/users', 'spree/base'
      include Spree::Core::ControllerHelpers::Auth
      # include Spree::Core::ControllerHelpers::Common
      # include Spree::Core::ControllerHelpers::Order

      ssl_required :new, :create, :destroy

      respond_to :json
      skip_before_filter :verify_authenticity_token

      def create
        authenticate_spree_user!

        if spree_user_signed_in?
          respond_with spree_current_user
          # respond_with spree_current_user.to_json(:only => [:email, :sign_in_count, :first_name, :last_name])
        else
          warden.custom_failure!
          render :json => {success: false, message: "Error with your login or password"}, status: 401
        end
      end

      def destroy
        # env['warden'].logout(:spree_user) #this might work if below fails
        sign_out(resource_name)
      end

    end


  end
end
