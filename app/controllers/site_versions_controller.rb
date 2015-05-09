class SiteVersionsController < ApplicationController
  skip_before_filter :check_site_version

  def show
    site_version = SiteVersion.by_permalink_or_default(params[:id])

    cookies[:site_version]  = site_version.permalink
    cookies[:ip_address]    = request.remote_ip

    if user = try_spree_current_user
      user.update_site_version(site_version)
    end

    # note. after this method we should transfer directly to new page, otherwize current order will be lost
    current_order.use_prices_from(site_version)

    redirect_to previous_location_or_default(root_url(site_version: site_version.permalink), params[:backlink])
  end

  private

  def previous_location_or_default(default_url, previous_location = nil)
    if previous_location
      previous_location
    elsif session[:previous_location].present?
      session[:previous_location]
    else
      default_url
    end
  end
end
