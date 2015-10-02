class SiteVersionsController < ApplicationController
  skip_before_filter :check_site_version

  def show
    @current_site_version = SiteVersion.by_permalink_or_default(params[:id])

    session[:site_version] = @current_site_version.code

    if user = try_spree_current_user
      user.update_site_version(@current_site_version)
    end

    # note. after this method we should transfer directly to new page, otherwise current order will be lost
    current_order.use_prices_from(@current_site_version)

    redirect_to previous_or_root_url(@current_site_version)
  end

  def close_country_warning
    session[:close_country_warning] = true
    redirect_to previous_or_root_url(current_site_version)
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
