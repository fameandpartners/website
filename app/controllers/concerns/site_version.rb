module Concerns
  module SiteVersion
    extend ActiveSupport::Concern

    included do
      attr_writer :current_site_version

      before_filter :check_site_version, unless: [:on_checkout_path, :request_not_get_or_ajax]
      before_filter :prepare_locale_warning

      helper_method :current_site_version, :site_versions_enabled?
    end

    def prepare_locale_warning
      geo_site_version = FindUsersSiteVersion.new(request_ip: request.ip).sv_chosen_by_ip || ::SiteVersion.default
      @locale_warning = Preferences::LocaleWarnPresenter.new(
        geo_site_version: geo_site_version,
        current_site_version: current_site_version
      )
    end

    def check_site_version
      if site_version_param != current_site_version.code
        @current_site_version = ::SiteVersion.by_permalink_or_default(site_version_param)
      end
    end

    def site_versions_enabled?
      @site_versions_enabled ||= (SiteVersion.count > 1)
    end

    def current_site_version
      @current_site_version ||= begin
        service = FindUsersSiteVersion.new(
          user: current_spree_user,
          url_param: params[:site_version],
          cookie_param: session[:site_version]
        )

        service.get.tap do |site_version|
          if current_spree_user && current_spree_user.site_version_id != site_version.id
            current_spree_user.update_column(:site_version_id, site_version.id)
          end
        end
      end
    end

    def site_version_param
      params[:site_version] || SiteVersion.default.code
    end

    private

    def on_checkout_path
      request.path.match('/checkout$')
    end

    def request_not_get_or_ajax
      !request.get? || request.xhr?
    end
  end
end
