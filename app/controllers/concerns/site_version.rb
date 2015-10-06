module Concerns
  module SiteVersion
    extend ActiveSupport::Concern

    included do
      attr_writer :current_site_version

      before_filter :show_locale_warning
      prepend_before_filter :enforce_param_site_version, unless: [:on_checkout_path, :request_not_get_or_ajax]

      helper_method :current_site_version
    end

    def show_locale_warning
      geo_site_version = ::FindUsersSiteVersion.new(request_ip: request.ip).sv_chosen_by_ip || ::SiteVersion.default
      @locale_warning  = ::Preferences::LocaleWarnPresenter.new(
          geo_site_version:          geo_site_version,
          current_site_version:      current_site_version,
          session_site_version_code: session[:site_version]
      )
    end

    def enforce_param_site_version
      if site_version_param != current_site_version.code
        new_site_version = ::SiteVersion.by_permalink_or_default(site_version_param)
        set_site_version(new_site_version)
      end
    end

    def current_site_version
      @current_site_version ||= begin
        ::FindUsersSiteVersion.new(
            user:         current_spree_user,
            url_param:    params[:site_version],
            cookie_param: session[:site_version]
        ).get
      end
    end

    def site_version_param
      params[:site_version] || ::SiteVersion.default.code
    end

    def current_currency
      current_site_version.try(:currency) || ::Spree::Config[:currency]
    end

    # TODO: This site version concern and `#set_site_version` method is doing too much. Time to extract this...
    def set_site_version(new_site_version = nil)
      raise ArgumentError unless new_site_version

      @current_site_version  = new_site_version
      session[:site_version] = new_site_version.code

      if (user = current_spree_user)
        user.update_attribute(:site_version_id, new_site_version.id)
      end

      if (order = session_order)
        order.use_prices_from(new_site_version)
      end
    end

    private

    def session_order
      ::Spree::Order.find_by_id session[:order_id]
    end

    def on_checkout_path
      request.path.match('/checkout$')
    end

    def request_not_get_or_ajax
      !request.get? || request.xhr?
    end
  end
end
