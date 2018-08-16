module Marketing
  module Gtm
    module Presenter
      class User < Base
        attr_reader :user, :session

        def initialize(spree_user:, session: {})
          @user       = spree_user
          @session    = session
        end

        def id
          logged_in? ? user.id: UNKNOWN_STRING
        end

        def name
          logged_in? ? "#{user.first_name} #{user.last_name}" : UNKNOWN_STRING
        end

        def first_name
          logged_in? ? user.first_name : UNKNOWN_STRING
        end

        def last_name
          logged_in? ? user.last_name : UNKNOWN_STRING
        end

        def email
          logged_in? ? user.email : UNKNOWN_STRING
        end

        def logged_in?
          user.respond_to?(:email)
        end

        def key
          'user'.freeze
        end

        def body
          {
            id:          id,
            email:       email,
            loggedIn:    logged_in?,
            name:        name,
            firstName:   first_name,
            lastName:    last_name
          }
        end
      end
    end
  end
end
