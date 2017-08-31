module Api
  module V1
    class UserSessionsController < Devise::SessionsController
      include SslRequirement
      helper 'spree/users', 'spree/base'
      include Spree::Core::ControllerHelpers::Auth
      include Spree::Core::ControllerHelpers::Common
      include Spree::Core::ControllerHelpers::Order

      ssl_required :new, :create, :destroy, :update

      respond_to :json
      skip_before_filter :verify_authenticity_token

      def create
        binding.pry
        authenticate_spree_user!

        if spree_user_signed_in?
          respond_to do |format|
            format.json {
              spree_current_user.to_json
            }
            format.html {
              binding.pry
              'asdf'
            }
          end
          # respond_with spree_current_user.to_json(:only => [:email, :sign_in_count, :first_name, :last_name])
        else
          respond_to do |format|
            format.json {
              binding.pry
              { suckit: true}
            }
            format.html {
              binding.pry
              "screw you"
            }
          end
        end
      end

    end


  end
end
