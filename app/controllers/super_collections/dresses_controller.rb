class SuperCollections::DressesController < ApplicationController
  include Marketing::Gtm::Controller::Collection
  include ProductsHelper
  respond_to :html

  layout 'custom_experience/application'
  attr_reader :page, :banner
  helper_method :page, :banner

  before_filter :redirect_undefined,
                :redirect_site_version

  def show

    title('Custom Bridesmaid Dress Collections', default_seo_title)
    description('Fully customizable bridesmaid dresses, tailored to your wedding theme, colors, and each bridesmaids\' individual needs.')

    @super_collection = {
      header: {
        img: "#{image_path('super_collections/1440_pineapple.jpg')}"
      },
      sections: [
        { type: 'shop_by', title: 'Theme', grid_class: 'grid-3_xs-1', sections: [
          { name: "Theme 1", img: "#{image_path('super_collections/635_egg.jpg')}", url: "/url-1" },
          { name: "Theme 2", img: "#{image_path('super_collections/635_egg.jpg')}", url: "/url-2" },
          { name: "Theme 3", img: "#{image_path('super_collections/635_egg.jpg')}", url: "/url-3" },
          { name: "Theme 4", img: "#{image_path('super_collections/635_egg.jpg')}", url: "/url-4" },
          { name: "Theme 5", img: "#{image_path('super_collections/635_egg.jpg')}", url: "/url-5" },
          { name: "Theme 6", img: "#{image_path('super_collections/635_egg.jpg')}", url: "/url-6" },
        ] },
        { type: 'shop_by', title: 'Season', grid_class: 'grid-3_xs-1', sections: [
          { name: "Season 1", img: "#{image_path('super_collections/635_egg.jpg')}", url: "/url-7" },
          { name: "Season 2", img: "#{image_path('super_collections/635_egg.jpg')}", url: "/url-8" },
          { name: "Season 3", img: "#{image_path('super_collections/635_egg.jpg')}", url: "/url-9" },
          { name: "Season 4", img: "#{image_path('super_collections/635_egg.jpg')}", url: "/url-10" },
          { name: "Season 5", img: "#{image_path('super_collections/635_egg.jpg')}", url: "/url-11" },
          { name: "Season 6", img: "#{image_path('super_collections/635_egg.jpg')}", url: "/url-12" },
        ] },
        { type: 'shop_by', title: 'Color', grid_class: 'grid-6_xs-1', sections: [
          { name: "Pale Pink", img: "#{image_path('super_collections/swatches/pale-pink.jpg')}", url: "/pale-pink-bridesmaid-dress" },
          { name: "Champagne", img: "#{image_path('super_collections/swatches/champagne.jpg')}", url: "/champagne-bridesmaid-dress" },
          { name: "Blush", img: "#{image_path('super_collections/swatches/blush.jpg')}", url: "/blush-pink-bridesmaid-dress" },
          { name: "Peach", img: "#{image_path('super_collections/swatches/peach.jpg')}", url: "/peach-bridesmaid-dress" },
          { name: "Guava", img: "#{image_path('super_collections/swatches/guava.jpg')}", url: "/guava-bridesmaid-dress" },
          { name: "Red", img: "#{image_path('super_collections/swatches/red.jpg')}", url: "/red-bridesmaid-dress" },
          { name: "Burgundy", img: "#{image_path('super_collections/swatches/burgundy.jpg')}", url: "/burgundy-bridesmaid-dress" },
          { name: "Berry", img: "#{image_path('super_collections/swatches/berry.jpg')}", url: "/berry-bridesmaid-dress" },
          { name: "Lilac", img: "#{image_path('super_collections/swatches/lilac.jpg')}", url: "/lilac-bridesmaid-dress" },
          { name: "Pale Blue", img: "#{image_path('super_collections/swatches/pale-blue.jpg')}", url: "/pale-blue-bridesmaid-dress" },
          { name: "Royal Blue", img: "#{image_path('super_collections/swatches/royal-blue.jpg')}", url: "/royal-blue-bridesmaid-dress" },
          { name: "Navy", img: "#{image_path('super_collections/swatches/navy.jpg')}", url: "/navy-bridesmaid-dress" },
          { name: "Black", img: "#{image_path('super_collections/swatches/black.jpg')}", url: "/black-bridesmaid-dress" },
          { name: "Pale Grey", img: "#{image_path('super_collections/swatches/pale-grey.jpg')}", url: "/pale-grey-bridesmaid-dress" },
          { name: "Ivory", img: "#{image_path('super_collections/swatches/ivory.jpg')}", url: "/ivory-bridesmaid-dress" },
          { name: "Mint", img: "#{image_path('super_collections/swatches/mint.jpg')}", url: "/mint-bridesmaid-dress" },
          { name: "Bright Turquoise", img: "#{image_path('super_collections/swatches/bright-turquoise.jpg')}", url: "/bright-turquoise-bridesmaid-dress" },
          { name: "Sage Green", img: "#{image_path('super_collections/swatches/sage-green.jpg')}", url: "/sage-green-bridesmaid-dress" },
        ] }
      ]
    }
  end

  private

  def image_path(image)
    ActionController::Base.helpers.image_path image
  end

  def redirect_site_version
    redirect_path = params.dig(:redirect, current_site_version.permalink.to_sym)
    if redirect_path.present?
      redirect_to url_for(redirect_path)
    end
  rescue NoMethodError => e
    # :noop:
  end

  def redirect_undefined
    if params[:permalink] =~ /undefined\Z/
      redirect_to '/undefined', status: :moved_permanently
    end
  end
end
