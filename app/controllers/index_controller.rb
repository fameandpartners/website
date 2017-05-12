class IndexController < ApplicationController
  layout 'redesign/application'

  def show
    # @test_num = load_rando
    # @home_page_container = home_page_container_from_contentful
    @instaTiles = get_contentful_parent_container
    @banner      = Spree::BannerBox.big_banner.for_site_version(current_site_version).limit(10)
    @title       = [homepage_title, default_seo_title].join(' ')
    @description = default_meta_description
    @iec_order = if params[:iec_order_number].present?
                   Spree::Order.where(number: params[:iec_order_number]).first
                 end
  end

  # def home_page_container_from_contentful
  #   blah = eval(get_contentful_parent_container)
  #   get_contentful_parent_container.entries(content_type: 'homePageContainer')[0]
  # end

  # def load_rando
  #   Rails.cache.fetch('load-rando-cache-key') do
  #     rand(1...50)
  #   end
  # end

  private

  def gtm_page_type
    'homepage'
  end

  def homepage_title
    Preferences::Titles.new(current_site_version).homepage_title
  end
end
