module Api
    class ApiBaseController < ActionController::Base
        include Concerns::SiteVersion

        skip_before_filter :show_locale_warning
        skip_before_filter :guarantee_session_site_version
        skip_before_filter :enforce_param_site_version
    end
end