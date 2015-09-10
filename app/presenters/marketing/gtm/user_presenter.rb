module Marketing
  module Gtm
    class UserPresenter < BasePresenter
      attr_reader :user, :request_ip

      def initialize(spree_user:, request_ip: nil)
        @request_ip = request_ip
        @user       = spree_user
      end

      def name
        logged_in? ? "#{user.first_name} #{user.last_name}" : UNKNOWN_STRING
      end

      def email
        logged_in? ? user.email : UNKNOWN_STRING
      end

      def logged_in?
        user.respond_to?(:email)
      end

      def gender
        raise NotImplementedError, '#gender is not yet implemented'
      end

      def facebook?
        raise NotImplementedError, '#facebook? is not yet implemented'
      end

      def country
        UserCountryFromIP.new(request_ip).country_name || UNKNOWN_STRING
      end

      def key
        'user'.freeze
      end

      def body
        {
            name:     name,
            # gender: gender,
            email:    email,
            loggedIn: logged_in?,
            # facebook: facebook?,
            country:  country
        }
      rescue StandardError => e
        NewRelic::Agent.notice_error(e)
        { error: e.message }
      end
    end
  end
end
