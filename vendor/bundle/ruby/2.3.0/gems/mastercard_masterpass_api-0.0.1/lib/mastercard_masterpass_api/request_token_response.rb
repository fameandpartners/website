module Mastercard
  module Masterpass
    class RequestTokenResponse < Mastercard::Masterpass::AccessTokenResponse
        attr_accessor :xoauth_request_auth_url, :oauth_token, :oauth_expires_in, :oauth_callback_confirmed, :oauth_token_secret
    end
  end
end