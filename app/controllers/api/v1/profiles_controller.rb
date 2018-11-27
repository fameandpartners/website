module Api
  module V1
    class ProfilesController < Users::BaseController
      include SslRequirement
      helper 'spree/users', 'spree/base'
      include Spree::Core::ControllerHelpers::Auth

      respond_to :json
      skip_before_filter :verify_authenticity_token

      ssl_required :update

      def update
        if spree_user_signed_in?
          @user = Spree::User.find_for_database_authentication(:email => params[:profile][:old_email])
          if @user.present? and @user.email == spree_current_user.email
            old_email = @user.email

            if @user.update_profile(params[:profile])
              if old_email != @user.email
                EmailCapture.new({ service: :mailchimp }, email: @user.email,
                  previous_email: old_email, first_name: @user.first_name,
                  last_name: @user.last_name, current_sign_in_ip: request.remote_ip,
                  landing_page: session[:landing_page], utm_params: session[:utm_params],
                  site_version: current_site_version.name, form_name: 'account_update').capture

                update_user_orders
              end
              
              sign_in("spree_user", @user)
              @user.remember_me!

              respond_with @user
              return
            end
          end
        end

        render :json=>{:success=>false, :message=>"Invalid arguments"}, :status=>401
      end

      private

      def update_user_orders
        @user.orders.each do |order|
          order.email = @user.email
          order.save
        end
      end

    end
  end
end
