class SiteVersionsController < ApplicationController
  def show
    site_version = SiteVersion.by_permalink_or_default(params[:id])
    self.current_site_version = site_version

    redirect_to root_url(site_version: site_version.permalink)
  end
end
