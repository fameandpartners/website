module OmniAuth
  module Strategies
    class Facebook
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
