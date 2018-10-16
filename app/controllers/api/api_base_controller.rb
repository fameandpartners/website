module Api
    class ApiBaseController < ActionController::Base
        include Spree::Core::ControllerHelpers::Order
        include Spree::Core::ControllerHelpers::Auth
        include Concerns::SiteVersion

        skip_before_filter :show_locale_warning
        skip_before_filter :guarantee_session_site_version
        skip_before_filter :enforce_param_site_version
        skip_before_filter :set_current_order
    end
end