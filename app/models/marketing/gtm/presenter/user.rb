module Marketing
  module Gtm
    module Presenter
      class User < Base
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
          if logged_in?
            user.facebook_data_value[:gender] || UNKNOWN_STRING
          else
            UNKNOWN_STRING
          end
        end

        def from_facebook?
          gender != UNKNOWN_STRING
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
              gender:   gender,
              email:    email,
              loggedIn: logged_in?,
              facebook: from_facebook?,
              country:  country
          }
        end
      end
    end
  end
end
