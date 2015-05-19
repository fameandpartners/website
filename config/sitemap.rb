ENV["RAILS_ENV"] ||= 'development'
require File.expand_path("../environment", __FILE__)
require 'rubygems'
require 'sitemap_generator'
require File.expand_path("../application", __FILE__)

# run locally: 
# bundle exec ruby config/sitemap.rb && xmllint --format public/sitemap.xm
# bundle exec rake sitemap:refresh - works too, but ping google/bing

# generated using gem 'sitemap_generator'
# how to run locally
# - this will put code in readable format
# bundle exec rake sitemap:refresh:no_ping && xmllint --format public/sitemap.xml
#
# on production
#   RAILS_ENV=production bundle exec ruby config/sitemap.rb 
#   RAILS_ENV=production bundle exec rake sitemap:refresh:no_ping
#
# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "http://#{configatron.host}"

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

    alternates + site_versions.map do |site_version|
      {
        href: absolute_url('/' + site_version.permalink + path), lang: site_version.locale, nofollow: false  
      }
    end
  end

  def map_taxon_products_images(taxon_id)
    taxon_products = Spree::Taxon.find(taxon_id).products.active
    cropped_products_images_for_sitemap(taxon_products)
  end

  # A color group is a Spree::OptionValue
  def map_color_group_products_images(color_id)
    products_with_color = Spree::Product.active.includes(option_types: :option_values).where('spree_option_values.id' => color_id)
    cropped_products_images_for_sitemap(products_with_color)
  end

  private

  def cropped_products_images_for_sitemap(product_array)
    images = []

    product_array.each do |product|
      image = Repositories::ProductImages.new(product: product).read(cropped: true)
      images.push({ loc: image.large, title: product.name }) if image
    end

    images
  end
end

# we create sitemap in xml, /public/sitemap.xml should be only symlink
options = {
  compress: true,
  include_root: false,
  sitemaps_path: 'sitemap' # folder not in repository
}

if Rails.env.development?
  SitemapGenerator::Sitemap.default_host = "http://localhost:3600"
end

unless Rails.env.development?
  SitemapGenerator::Sitemap.adapter = SitemapGenerator::S3Adapter.new(
    :aws_access_key_id => configatron.aws.s3.access_key_id,
    :aws_secret_access_key => configatron.aws.s3.secret_access_key,
    :fog_provider => 'AWS',
    :fog_directory => configatron.aws.s3.bucket,
    :fog_region => configatron.aws.s3.region
  )
end

SitemapGenerator::Sitemap.create(options) do
  add root_path, alternates: build_alternates(root_path), priority: 1.0

  # products page
  Spree::Product.active.each do |product|
    images_repo = Repositories::ProductImages.new(product: product)

    add(collection_product_path(product), {
      priority: 0.8,
      images: images_repo.filter(cropped: false).map { |img| { loc: img.large, title: product.name } },
      alternates: build_alternates(collection_product_path(product))
    })
  end

  # events
  Repositories::Taxonomy.read_events.each do |taxon|
    add(build_taxon_path(taxon.name), {
      priority: 0.7,
      images: map_taxon_products_images(taxon.id),
      alternates: build_alternates(build_taxon_path(taxon.name))
    })
  end

  # collections
  Repositories::Taxonomy.read_collections.each do |taxon|
    add(build_taxon_path(taxon.name), {
      priority: 0.7,
      images: map_taxon_products_images(taxon.id),
      alternates: build_alternates(build_taxon_path(taxon.name))
    })
  end

  # styles
  Repositories::Taxonomy.read_styles.each do |taxon|
    add(build_taxon_path(taxon.name), {
      priority: 0.7,
      images: map_taxon_products_images(taxon.id),
      alternates: build_alternates(build_taxon_path(taxon.name))
    })
  end

  # color groups
  Repositories::ProductColors.color_groups.each do |color_group|
    path = colour_path(color_group.name)
    add(path, {
      priority: 0.7,
      images: map_color_group_products_images(color_group.id),
      alternates: build_alternates(path)
    })
  end

  # Static pages
  localizable_statics_pages = [
    '/about', '/why-us', '/privacy',
    '/style-consultation', '/fame-chain',
    '/fashionitgirl2015',
    '/bridesmaid-dresses', '/sale-dresses',
    '/unidays'
  ]

  static_pages = [
    '/assets/returnform.pdf'
  ]

  localizable_statics_pages.each do |page_path|
    add page_path, priority: 0.5, alternates: build_alternates(page_path)
  end

  static_pages.each do |page_path|
    add page_path, priority: 0.5
  end
end

unless Rails.env.development?
  SitemapGenerator::Sitemap.ping_search_engines('http://images.fameandpartners.com/sitemap/sitemap.xml.gz')

  # Delete local Sitemap files. They all were uploaded to S3
  FileUtils.rm_rf File.join(SitemapGenerator::Sitemap.public_path, SitemapGenerator::Sitemap.sitemaps_path)
end
