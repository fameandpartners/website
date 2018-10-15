module Api
  module V1
    class ProfilesController < Users::BaseController
      respond_to :json
      skip_before_filter :verify_authenticity_token

      def update
        @user = Spree::User.find_for_database_authentication(:email => params[:profile][:old_email])
        if @user.present?
          old_email = @user.email

          if @user.update_profile(params[:profile])
            EmailCapture.new({ service: :mailchimp }, email: @user.email,
                                        previous_email: old_email, first_name: @user.first_name,
                                        last_name: @user.last_name, current_sign_in_ip: request.remote_ip,
                                        landing_page: session[:landing_page], utm_params: session[:utm_params],
                                        site_version: current_site_version.name, form_name: 'account_update').capture
            if old_email != @user.email
              update_user_orders
            end
            
            respond_with @user
            return
          end
        end

        render :json=>{:success=>false, :message=>"Invalid arguments"}, :status=>401
      end

    end


  end
end
