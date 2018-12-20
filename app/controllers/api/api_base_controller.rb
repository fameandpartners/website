module Api
    class ApiBaseController < ActionController::Base
        include Spree::Core::ControllerHelpers::Order
        include Spree::Core::ControllerHelpers::Auth
        include Spree::AuthenticationHelpers
        include Concerns::SiteVersion

        if Features.active?(:force_sitewide_ssl)
            ssl_required
        end

        skip_before_filter :set_current_order

        def default_serializer_options
            {
                root: false,
                scope: {
                    current_user: current_spree_user
                }
            }
        end
    end
end