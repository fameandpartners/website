require 'twilio-ruby'
require_dependency "wedding_atelier/application_controller"

module WeddingAtelier
  class TwilioController < ApplicationController

    protect_from_forgery except: :token

    def token
      token = get_token
      grant = get_grant
      token.add_grant(grant)
      render json: { username: identity, token: token.to_jwt }
    end

    private
    def get_token
      Twilio::Util::AccessToken.new(
        ENV['TWILIO_ACCOUNT_SID'],
        ENV['TWILIO_API_KEY'],
        ENV['TWILIO_API_SECRET'],
        3600,
        identity
      )
    end

    def get_grant
      grant = Twilio::Util::AccessToken::IpMessagingGrant.new
      grant.endpoint_id = "Chatty:#{identity.gsub(" ", "_")}:browser"
      grant.service_sid = ENV['TWILIO_IPM_SERVICE_SID']
      grant
    end

    private
    def identity
      spree_current_user.email =~ /^.*@fameandpartners.com$/ ? 'Amber (Fame Stylist)' : spree_current_user.full_name
    end
  end
end
