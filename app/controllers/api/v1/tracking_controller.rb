module Api
  module V1
    class TrackingController < ApplicationController 
      respond_to :json
      skip_before_filter :verify_authenticity_token

      def track          
        head :no_content
      end

      def subscribe_newsletter
        user = Spree::User.find_by_email(params['email']) || Spree::User.new(email: params['email'])

        KlaviyoService.new({},
          email: user.email,
          newsletter: user.newsletter,
          first_name: user.first_name,
          last_name: user.last_name,
          current_sign_in_ip: request.remote_ip,
          landing_page: session[:landing_page],
          utm_params: session[:utm_params],
          site_version: current_site_version.name,
          form_name: 'checkout').subscribe_list

        render json: user, status: :ok
      end
    end
  end
end
