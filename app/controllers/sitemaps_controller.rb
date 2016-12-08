class SitemapsController < ActionController::Base
  SITEMAP_BASE_URL = "#{ENV['RAILS_ASSET_HOST']}/sitemap/"

  # GET /sitemap_index.xml
  # GET /sitemap_index.xml.gz
  def index
    redirect_to configatron.sitemap_url, status: :moved_permanently
  end

  # GET /sitemap.xml
  # GET /sitemap.xml.gz
  # GET /au/sitemap.xml
  # GET /au/sitemap.xml.gz
  def show
    site_version = request.env['site_version_code'] || SiteVersion.default.permalink
    sitemap_url = URI.join(SITEMAP_BASE_URL, "#{site_version}.xml.gz").to_s
    redirect_to sitemap_url, status: :moved_permanently
  end
end
