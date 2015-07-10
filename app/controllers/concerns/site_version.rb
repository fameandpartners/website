module Concerns::SiteVersion
  extend ActiveSupport::Concern

  included do
    attr_writer :current_site_version

    helper_method :current_site_version, :site_versions_enabled?
  end

  def site_versions_enabled?
    @site_versions_enabled ||= (SiteVersion.count > 1)
  end

  def current_site_version
    @current_site_version ||= begin
      service = FindUsersSiteVersion.new(
        user: current_spree_user,
        url_param: params[:site_version],
        cookie_param: cookies[:site_version],
        request_ip: request.remote_ip
      )

      service.get.tap do |site_version|
        if current_spree_user && current_spree_user.site_version_id != site_version.id
          current_spree_user.update_column(:site_version_id, site_version.id)
        end
      end
    end
  end

  def param_site_version
    params[:site_version] || SiteVersion.default.code
  end

  def set_site_version_cookie(site_version_code)
    cookies.permanent[:site_version] = site_version_code
  end
end
