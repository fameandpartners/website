require 'twilio-ruby'
require_dependency "wedding_atelier/application_controller"

module WeddingAtelier
  class TwilioController < ApplicationController

    protect_from_forgery except: :token

    def token
      token = get_token
      grant = get_grant
      token.add_grant(grant)
      render json: {username: spree_current_user.full_name, token: token.to_jwt}
    end

    private
    def get_token
      Twilio::Util::AccessToken.new(
        ENV['TWILIO_ACCOUNT_SID'],
        ENV['TWILIO_API_KEY'],
        ENV['TWILIO_API_SECRET'],
        3600,
        spree_current_user.full_name
      )
    end

    def get_grant
      grant = Twilio::Util::AccessToken::IpMessagingGrant.new
      grant.endpoint_id = "Chatty:#{spree_current_user.full_name.gsub(" ", "_")}:browser"
      grant.service_sid = ENV['TWILIO_IPM_SERVICE_SID']
      grant
    end
  end
end
