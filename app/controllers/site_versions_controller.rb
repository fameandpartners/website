class SiteVersionsController < ApplicationController
  skip_before_filter :enforce_param_site_version

  def show
    @current_site_version = SiteVersion.by_permalink_or_default(params[:id])

    set_site_version(site_version_code: @current_site_version.code)

    redirect_to previous_or_root_url(@current_site_version)
  end

  private

  def previous_or_root_url(site_version)
    if request.referrer.present?
      LocalizeUrlService.localize_url(request.referrer, site_version)
    else
      root_url(site_version: site_version.permalink)
    end
  end
end
