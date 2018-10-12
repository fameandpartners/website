class SitemapsController < ActionController::Base
  SITEMAP_BASE_URL = "#{ENV['RAILS_ASSET_HOST']}/sitemap/"

  # GET /sitemap_index.xml
  # GET /sitemap_index.xml.gz
  def index
    site_version = request.env['site_version_code'] || SiteVersion.default.permalink
    sitemap_url = URI.join(SITEMAP_BASE_URL, "#{site_version}.xml.gz").to_s
    redirect_to sitemap_url, status: :moved_permanently
  end
end
