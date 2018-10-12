# run locally:
# bundle exec rake sitemap:create
# bundle exec rake sitemap:refresh - works too, but ping google/bing
# - if you wish to format the XML into something more human readable, you can use the command `xmllint --format sitemap.xml`
# => Note: on production, if you run the sitemap:create rake task, it'll automatically ping search engines
#

unless Rails.env.development?
  SitemapGenerator::Sitemap.adapter = SitemapGenerator::FogAdapter.new(
    fog_credentials: {
      use_iam_profile: true,
      provider:        'AWS',
      region:          ENV['AWS_S3_REGION']
    },
    fog_host:        ENV['RAILS_ASSET_HOST'],
    fog_directory:   ENV['AWS_S3_BUCKET'],
  )
end

SitemapGenerator::Interpreter.send :include, PathBuildersHelper

SitemapGenerator::Interpreter.class_eval do
  def site_version_default_host(site_version)
    detector.site_version_url(ENV['APP_HOST'], site_version).chomp('/')
  end

  private def detector
    UrlHelpers::SiteVersion::Detector.detector
  end
end

SiteVersion.all.each do |site_version|
    sitemap_options = {
      compress:      Rails.env.production?,
      default_host:  site_version_default_host(site_version),
      sitemaps_host: ENV['RAILS_ASSET_HOST'],
      filename: site_version.permalink,
      sitemaps_path: "sitemap"
    }

  SitemapGenerator::Sitemap.create(sitemap_options) do
    add_to_index("/_webclient/sitemap/plp.xml", host: site_version_default_host(site_version))
    add_to_index("/_webclient/sitemap/pdp.xml", host: site_version_default_host(site_version))
    add_to_index("/_webclient/sitemap/cms.xml", host: site_version_default_host(site_version))
 
    add '/assets/returnform.pdf', priority: 0.7
    statics_pages      = %w(/why-us /privacy /terms)
    statics_pages.each do |page_path|
      add page_path, priority: 0.7
    end
  end

  if Rails.env.production?
    SiteVersion.all.each do |site_version|
      SitemapGenerator::Sitemap.ping_search_engines("#{sitemap_options[:sitemaps_host]}/#{sitemap_options[:sitemaps_path]}/#{sitemap_options[:filename]}.xml.gz")
    end

    # Delete local Sitemap files. They all were uploaded to S3
    FileUtils.rm_rf File.join(SitemapGenerator::Sitemap.public_path, SitemapGenerator::Sitemap.sitemaps_path)
  end
end
