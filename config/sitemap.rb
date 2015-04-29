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

SitemapGenerator::Interpreter.send :include, ApplicationHelper
SitemapGenerator::Interpreter.send :include, ProductsHelper
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
    alternates = [{ href: absolute_url(path), lang: 'en', nofollow: false }]

    alternates + site_versions.map do |site_version|
      {
        href: absolute_url('/' + site_version.permalink + path), lang: site_version.locale, nofollow: false  
      }
    end
  end

  def post_path(post)
    return '#' if post.nil?
    if (category = post.category).present?
      blog_post_by_category_path(category_slug: category.slug, post_slug: post.slug) 
    else
      blog_post_path(post_slug: post.slug)
    end
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
  # add '/' - added by default
  # have to add /en & /au
  default_site_version = SiteVersion.default
  site_versions = SiteVersion.where(default: false).to_a

  add root_path, alternates: build_alternates(root_path), priority: 1.0

  # products page
  Spree::Product.active.each do |product|
    color_ids = product.variants.active.map do |variant|
      variant.option_values.colors.map(&:id)
    end.flatten.uniq

    images_repo = Repositories::ProductImages.new(product: product)

    product.product_color_values.each do |product_color_value|
      color = product_color_value.option_value
      color_images = images_repo.filter(color_id: color.id)

      next unless color_ids.include?(color.id)
      next unless color_images.present?

      add(collection_product_path(product, color: color.name), {
        priority: 0.8,
        images: color_images.map{|data| { loc: data.large, title: product.name }},
        alternates: build_alternates(collection_product_path(product, color: color.name))
      })
    end
  end
  # events
  Repositories::Taxonomy.read_events.each do |taxon|
    add(build_taxon_path(taxon.name), {
      priority: 0.7,
      alternates: build_alternates(build_taxon_path(taxon.name))
    })
  end

  # collections
  Repositories::Taxonomy.read_collections.each do |taxon|
    add(build_taxon_path(taxon.name), {
      priority: 0.7,
      alternates: build_alternates(build_taxon_path(taxon.name))
    })
  end

  # styles
  Repositories::Taxonomy.read_styles.each do |taxon|
    add(build_taxon_path(taxon.name), {
      priority: 0.7,
      alternates: build_alternates(build_taxon_path(taxon.name))
    })
  end

  # color groups
  Repositories::ProductColors.color_groups.each do |color_group|
    path = colour_path(color_group.name)
    add(path, priority: 0.7, alternates: build_alternates(path))
  end

  statics_pages = [ 
    '/about', '/why-us', '/team', '/terms', '/privacy', '/legal', '/faqs', '/how-it-works',
    '/fashionista2014', '/fashionista2014/info', '/fashionista2014-winners', '/compterms', '/plus-size',
    '/style-consultation', '/fame-chain', '/returnsform',
    '/fashionitgirl2015', '/fashionitgirl2015-terms-and-conditions', '/fashionitgirl2015-competition',
    '/nyfw-comp-terms-and-conditions', '/bridesmaid-dresses', '/feb_2015_lp', '/facebook-lp', '/sale-dresses', '/fame2015',
    '/unidays'
  ]
  statics_pages.each do |page_path|
    add page_path, priority: 0.5, alternates: build_alternates(page_path)
  end
end

unless Rails.env.development?
  SitemapGenerator::Sitemap.ping_search_engines
end
