# Make sure the site never ever ever tries to hit the possibly
# down `alerts.spreecommerce.com` on admin page load.
# The setting is turned off in production, but this module smashes
# into Spree so that it can never be on again. Ever.
#
# Spree::Preference.find_by_key 'spree/app_configuration/check_for_spree_alerts'
# See spree-core app/controllers/spree/admin/base_controller.rb
module Spree
  module Admin
    module SkipSpreeCommerceAlerts
      extend ActiveSupport::Concern

      included do
        # While turning off the before hook is probably enough,
        skip_before_filter :check_alerts

        # Let's just nuke the feature from orbit,
        def check_alerts
          # NOOP
        end

        # And kill it with fire.
        def should_check_alerts?
          false
        end
      end
    end
  end
end
