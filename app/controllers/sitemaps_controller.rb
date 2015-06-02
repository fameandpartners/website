class SitemapsController < ActionController::Base
  SITEMAP_BASE_URL = "http://#{configatron.aws.host}/sitemap/"

  # GET /sitemap_index.xml
  # GET /sitemap_index.xml.gz
  def index
    redirect_to configatron.sitemap_url, status: :moved_permanently
  end

  # GET /images_sitemap.xml.gz
  # GET /images_sitemap.xml
  def images
    images_sitemap_url = URI.join(SITEMAP_BASE_URL, 'images.xml.gz').to_s
    redirect_to images_sitemap_url, status: :moved_permanently
  end

  # GET /sitemap.xml
  # GET /sitemap.xml.gz
  # GET /au/sitemap.xml
  # GET /au/sitemap.xml.gz
  def show
    site_version = params[:site_version] || SiteVersion.default.permalink
    sitemap_url = URI.join(SITEMAP_BASE_URL, "#{site_version}.xml.gz").to_s
    redirect_to sitemap_url, status: :moved_permanently
  end
end
