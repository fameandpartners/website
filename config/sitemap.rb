# run locally:
# bundle exec rake sitemap:create
# bundle exec rake sitemap:refresh - works too, but ping google/bing
# - if you wish to format the XML into something more human readable, you can use the command `xmllint --format sitemap.xml`
# => Note: on production, if you run the sitemap:create rake task, it'll automatically ping search engines
#

unless Rails.env.development?
  SitemapGenerator::Sitemap.adapter = SitemapGenerator::S3Adapter.new(
    :aws_access_key_id => configatron.aws.s3.access_key_id,
    :aws_secret_access_key => configatron.aws.s3.secret_access_key,
    :fog_provider => 'AWS',
    :fog_directory => configatron.aws.s3.bucket,
    :fog_region => configatron.aws.s3.region
  )
end

SitemapGenerator::Interpreter.send :include, PathBuildersHelper

SitemapGenerator::Interpreter.class_eval do
  def absolute_url(path = '/')
    path = ('/' + path).gsub(/\/+/, '/')
    url = "#{ SitemapGenerator::Sitemap.default_host }#{ path }"
  end

  def site_versions
    @_site_version ||= SiteVersion.where(default: false).to_a
  end

  # make links for all site versions
  # version for default - without prefix
  # <xhtml:link rel="alternate" hreflang="en" href="http://example.com" />
  # <xhtml:link rel="alternate" hreflang="en-AU" href="http://example.com/au" />
  def build_alternates(path)
    alternates = [{ href: absolute_url(path), lang: 'en-US', nofollow: false }]

    alternates + site_versions.map { |site_version| alternate_href_hash(path, site_version) }
  end

  def alternate_href_hash(path, site_version)
    { href: absolute_url('/' + site_version.permalink + path), lang: site_version.locale }
  end
end

sitemap_options = {
  compress: Rails.env.production?,
  default_host: "http://#{configatron.host}",
  sitemaps_host: "http://#{configatron.aws.host}",
  include_root: false,
  sitemaps_path: 'sitemap'
}

# XML Priorities:
# => 1.0 for root (generator's `#include_root` default)
# => 0.9 for categories
# => 0.8 for products
# => 0.7 for pages
SitemapGenerator::Sitemap.create(sitemap_options) do
  # Records scopes
  active_products    = Spree::Product.active
  events_taxons      = Spree::Taxon.published.from_event_taxonomy
  collections_taxons = Spree::Taxon.published.from_range_taxonomy
  styles_taxons      = Spree::Taxon.published.from_style_taxonomy
  colors_taxons      = Spree::OptionValuesGroup.for_colors.available_as_taxon
  statics_pages = [
    '/about', '/why-us', '/privacy',
    '/style-consultation', '/fame-chain',
    '/fashionitgirl2015',
    '/bridesmaid-dresses', '/sale-dresses',
    '/unidays'
  ]

  # Common pages
  add '/assets/returnform.pdf', priority: 0.7

  # Creating sitemaps for each site version
  SiteVersion.find_each do |site_version|
    sitemap_group_options = {
      default_host: "http://#{configatron.host}/#{site_version.to_param}",
      filename: site_version.permalink
    }

    group(sitemap_group_options) do
      # Root
      add '/', alternate: alternate_href_hash('/', site_version)

      # Products pages
      active_products.each do |product|
        product_images = Repositories::ProductImages.new(product: product).read_all
        product_images = product_images.map { |image| { loc: image.original, title: [product.name, image.color].join(' ') } }
        product_url = collection_product_path(product)

        add product_url, alternate: alternate_href_hash(product_url, site_version), images: product_images, priority: 0.8
      end

      # Events
      events_taxons.each do |taxon|
        taxon_url = build_taxon_path(taxon.name)
        add taxon_url, alternate: alternate_href_hash(taxon_url, site_version), priority: 0.9
      end

      # Collections
      collections_taxons.each do |taxon|
        taxon_url = build_taxon_path(taxon.name)
        add taxon_url, alternate: alternate_href_hash(taxon_url, site_version), priority: 0.9
      end

      # Styles
      styles_taxons.each do |taxon|
        taxon_url = build_taxon_path(taxon.name)
        add taxon_url, alternate: alternate_href_hash(taxon_url, site_version), priority: 0.9
      end

      # Color Groups
      colors_taxons.each do |color_group|
        color_url = colour_path(color_group.name)
        add color_url, alternate: alternate_href_hash(color_url, site_version), priority: 0.9
      end

      # Static pages
      statics_pages.each do |page_path|
        add page_path, alternate: alternate_href_hash(page_path, site_version), priority: 0.7
      end
    end
  end
end

unless Rails.env.development?
  SitemapGenerator::Sitemap.ping_search_engines("#{sitemap_options[:sitemaps_host]}/#{sitemap_options[:sitemaps_path]}/sitemap.xml.gz")

  # Delete local Sitemap files. They all were uploaded to S3
  FileUtils.rm_rf File.join(SitemapGenerator::Sitemap.public_path, SitemapGenerator::Sitemap.sitemaps_path)
end
