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
    '/bridesmaid-dresses',
    '/unidays'
  ]

  # Common pages
  add '/assets/returnform.pdf', priority: 0.7

  # Creating sitemaps for each site version
  SiteVersion.find_each do |site_version|
    sitemap_group_options = {
      include_root: true,
      default_host: "http://#{configatron.host}/#{site_version.to_param}",
      filename: site_version.permalink
    }

    group(sitemap_group_options) do
      # Products pages
      active_products.find_each do |product|
        product_images = Repositories::ProductImages.new(product: product).read_all
        product_images = product_images.map { |image| { loc: image.original, title: [product.name, image.color].join(' ') } }

        add collection_product_path(product), images: product_images, priority: 0.8
      end

      # Events, Styles and Collections (Ranges)
      (events_taxons + collections_taxons + styles_taxons).each do |taxon|
        add build_taxon_path(taxon.name), priority: 0.9
      end

      # Color Groups
      colors_taxons.each do |color_group|
        add colour_path(color_group.name), priority: 0.9
      end

      # Static pages
      statics_pages.each do |page_path|
        add page_path, priority: 0.7
      end
    end
  end
end

unless Rails.env.development?
  SitemapGenerator::Sitemap.ping_search_engines("#{sitemap_options[:sitemaps_host]}/#{sitemap_options[:sitemaps_path]}/sitemap.xml.gz")

  # Delete local Sitemap files. They all were uploaded to S3
  FileUtils.rm_rf File.join(SitemapGenerator::Sitemap.public_path, SitemapGenerator::Sitemap.sitemaps_path)
end
