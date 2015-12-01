module SiteVersionRoutingHelper
  def site_version_url(current_url, site_version)
    detector.site_version_url(current_url, site_version)
  end

  private

  def detector
    configatron.site_version_detector.new
  end
end
