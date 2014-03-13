class SiteVersionsController < ApplicationController
  skip_before_filter :check_site_version

  def show
    site_version = SiteVersion.by_permalink_or_default(params[:id])

    cookies[:site_version]  = site_version.permalink
    cookies[:ip_address]    = request.remote_ip

    if user = try_spree_current_user
      user.update_site_version(site_version)
    end

    redirect_to previous_location_or_default(root_url(site_version: site_version.permalink))
  end
end
