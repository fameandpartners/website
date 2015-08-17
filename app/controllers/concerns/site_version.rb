module Concerns::SiteVersion
  extend ActiveSupport::Concern

  included do
    attr_writer :current_site_version

    before_filter :show_locale_warning
    before_filter :check_site_version

    helper_method :current_site_version, :site_versions_enabled?
  end

  def show_locale_warning
    geo_site_version = FindUsersSiteVersion.new(request_ip: request.ip).sv_chosen_by_ip || ::SiteVersion.default
    @locale_warning = Preferences::LocaleWarnPresenter.new(
      geo_site_version: geo_site_version,
      current_site_version: current_site_version,
      session_site_version_code: session[:site_version]
    )
  end

  def check_site_version
    # Add to cart and submitting forms should not change site version
    return :no_change if (!request.get? || request.xhr? || request.path == '/checkout')

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
end
