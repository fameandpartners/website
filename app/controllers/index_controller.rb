require 'rest-client'
class IndexController < ApplicationController
  layout 'redesign/application'

  def show
    @banner      = Spree::BannerBox.big_banner.for_site_version(current_site_version).limit(10)
    @title       = [homepage_title, default_seo_title].join(' ')
    @description = default_meta_description
    @blog_posts  = blog_posts
    if Features.active?(:maintenance)
      render :action => 'maintenance', :layout => 'redesign/maintenance'
    end
  end

  private

  def gtm_page_type
    'homepage'
  end

  def homepage_title
    Preferences::Titles.new(current_site_version).homepage_title
  end

  def blog_posts
    xml = RestClient.get('http://blog.fameandpartners.com/rss')
    doc = Nokogiri::XML(xml)

    blogs = []
    doc.search('//item').each do |item|
      blog = {}
      blog[:title]       = item.search('title').text
      blog[:description] = item.search('description').text
      blog[:link]        = item.search('link').text
      blogs << blog
    end
    blogs
  end
end
