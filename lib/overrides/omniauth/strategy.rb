module OmniAuth
  module Strategies
    class Facebook
      option :client_options, {
         site: 'https://graph.facebook.com/v3.1',
         token_url: '/oauth/access_token',
         authorize_url: "https://www.facebook.com/v3.1/dialog/oauth"
      }

      def on_request_path?
        !!(current_path =~ /^\/?(au|us)?\/user\/auth\/facebook$/i)
      end

      def site_version
        @site_version ||= /^\/?(au|us)/i.match(current_path).try(:[], 1)
      end

      def request_path
        '/' + [site_version, 'user/auth/facebook'].compact.join('/')
      end

      def callback_path
        '/' + [site_version, 'user/auth/facebook/callback'].compact.join('/')
      end
    end
  end
end
