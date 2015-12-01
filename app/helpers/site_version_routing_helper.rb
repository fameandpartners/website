module SiteVersionRoutingHelper
  def site_version_url(current_url, site_version)
    LocalizeUrlService.localize_url(current_url, site_version)
  end
end
