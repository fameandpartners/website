ENV["RAILS_ENV"] ||= 'development'
require File.expand_path("../environment", __FILE__)
require 'rubygems'
require 'sitemap_generator'
require File.expand_path("../application", __FILE__)

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

SitemapGenerator::Interpreter.class_eval do
  def collection_product_path(product, options = {})
    taxon = range_taxon_for(product)
    if taxon
      taxon_permalink = taxon.permalink.split('/').last
      build_collection_product_path(taxon_permalink, product.to_param, options)
    else
      "/collection/long-dresses/#{ product.permalink }"
    end
  end
end

# we create sitemap in xml, /public/sitemap.xml should be only symlink
options = {
  compress: true,
  sitemaps_path: 'system' # folder not in repository
}

if Rails.env.development?
  SitemapGenerator::Sitemap.default_host = "http://localhost:3600"
  options[:compress] = false
end

SitemapGenerator::Sitemap.create(options) do
  # add '/' - added by default

  # products page
  Spree::Product.active.each do |product|
    add collection_product_path(product), {
      priority: 0.8,
      images: product.images_json.collect {|data| { loc: data[:large], title: product.name }}
    }
  end

  # collection page
  available_product_ranges.each do |collection|
    add collection.permalink, { priority: 0.7 }
  end

  statics_pages = [
    '/about', '/why-us', '/team', '/privacy', '/legal', '/how-it-works'
  ]
  statics_pages.each do |page_url|
    add page_url, priority: 0.5
  end

  Celebrity.published.each do |celebrity|
    add "/celebrities/#{celebrity.slug}", priority: 0.3
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
