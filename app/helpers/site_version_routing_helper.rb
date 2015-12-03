module SiteVersionRoutingHelper
  def site_version_url(current_url, site_version)
    detector.site_version_url(current_url, site_version)
  end

  private

  def detector
    UrlHelpers::SiteVersion::Detector.detector
  end
end
