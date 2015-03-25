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
# bundle exec rake sitemap:refresh:no_ping && cat public/sitemap.xml | xmllint --format -
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

# we create sitemap in xml, /public/sitemap.xml should be only symlink
options = {
  compress: true,
  sitemaps_path: 'system' # folder not in repository
}

if Rails.env.development?
  SitemapGenerator::Sitemap.default_host = "http://localhost:3600"
  options[:compress] = false
end

SitemapGenerator::Sitemap.create_index = false
SitemapGenerator::Sitemap.create(options) do
  # add '/' - added by default
  # have to add /en & /au
  default_site_version = SiteVersion.default
  site_versions = SiteVersion.where(default: false).to_a

  add root_path(site_version: default_site_version), alternates: site_versions.map{|site_version|
    { href: root_path(site_version: site_version.permalink), lang: site_version.locale, nofollow: true  }
  }

  # products page
  Spree::Product.active.limit(1).each do |product|
    images = Repositories::ProductImages.new(product: product).read_all
    add(collection_product_path(product, site_version: default_site_version.permalink), {
      priority: 0.8,
      images: images.map{|data| { loc: data.large, title: product.name }},
      alternates: site_versions.map{|site_version|
        { href: collection_product_path(product, site_version: site_version.permalink), lang: site_version.locale, nofollow: true }
      }
    })
  end

  # events
  Repositories::Taxonomy.read_events.each do |taxon|
    add(build_taxon_path(taxon.name, site_version: default_site_version.permalink), {
      priority: 0.7,
      alternates: site_versions.map{|site_version|
        { href: build_taxon_path(taxon.name, site_version: site_version.permalink), lang: site_version.locale, nofollow: true }
      }
    })
  end

  # collections
  Repositories::Taxonomy.read_collections.each do |taxon|
    add(build_taxon_path(taxon.name, site_version: default_site_version.permalink), {
      priority: 0.7,
      alternates: site_versions.map{|site_version|
        { href: build_taxon_path(taxon.name, site_version: site_version.permalink), lang: site_version.locale, nofollow: true }
      }
    })
  end

  # styles
  Repositories::Taxonomy.read_styles.each do |taxon|
    add(build_taxon_path(taxon.name, site_version: default_site_version.permalink), {
      priority: 0.7,
      alternates: site_versions.map{|site_version|
        { href: build_taxon_path(taxon.name, site_version: site_version.permalink), lang: site_version.locale, nofollow: true }
      }
    })
  end

  statics_pages = [
    '/about', '/why-us', '/team', '/privacy', '/legal', '/how-it-works'
  ]
  statics_pages.each do |page_url|
    add page_url, priority: 0.5, alternates: site_versions.map{|site_version|
      { href: "/#{ site_version.permalink}#{ page_url }", lang: site_version.locale, nofollow: true }
    }
  end

  # celebrities
  Celebrity.published.each do |celebrity|
    add "/celebrities/#{celebrity.slug}", priority: 0.3, alternates: site_versions.map{|site_version|
      { href: "/#{ site_version.permalink }/celebrities/#{ celebrity.slug }", lang: site_version.locale, nofollow: true }
    }
  end
end

file_name = options[:compress] ? 'sitemap.xml.gz' : 'sitemap.xml'
target_file_path = File.join(Rails.root, 'public', file_name)
source_file_path = File.join(Rails.root, 'public', 'system', file_name)

# create symlink
if !FileTest.exists?(target_file_path) #&& FileTest.exists?(source_file_path)
  system("ln -s #{source_file_path} #{target_file_path}")
end

unless Rails.env.development?
  SitemapGenerator::Sitemap.ping_search_engines("http://#{configatron.host}/#{ file_name }")
end
