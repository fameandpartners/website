require 'sentry-raven'

module Errors
  module Sentry
    module ControllerConcern
      extend ActiveSupport::Concern

      included do
        before_filter :set_sentry_context
      end

      def set_sentry_context
        Raven.user_context(user_id: spree_current_user.try(:id))
        Raven.extra_context(params: params.to_hash, url: request.url)
      end
    end
  end
end
