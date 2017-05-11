class IndexController < ApplicationController
  layout 'redesign/application'

  def show
    @home_page_container = home_page_container_from_contentful
    @banner      = Spree::BannerBox.big_banner.for_site_version(current_site_version).limit(10)
    @title       = [homepage_title, default_seo_title].join(' ')
    @description = default_meta_description
    @iec_order = if params[:iec_order_number].present?
                   Spree::Order.where(number: params[:iec_order_number]).first
                 end
  end

  def home_page_container_from_contentful
    get_contentful_parent_container.entries(content_type: 'homePageContainer')[0]
  end

  private

  def gtm_page_type
    'homepage'
  end

  def homepage_title
    Preferences::Titles.new(current_site_version).homepage_title
  end
end
