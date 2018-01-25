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
    @super_collection = {
      header: {
        img: "#{image_path('super_collections/1440_pineapple.jpg')}"
      },
      sections: [
        { type: 'shop_by', title: 'Theme', sections: [
          { img: "#{image_path('super_collections/635_egg.jpg')}" },
          { img: "#{image_path('super_collections/635_egg.jpg')}" },
          { img: "#{image_path('super_collections/635_egg.jpg')}" },
          { img: "#{image_path('super_collections/635_egg.jpg')}" },
          { img: "#{image_path('super_collections/635_egg.jpg')}" },
          { img: "#{image_path('super_collections/635_egg.jpg')}" },
        ] },
        { type: 'shop_by', title: 'Season', sections: [
          { img: "#{image_path('super_collections/635_egg.jpg')}" },
          { img: "#{image_path('super_collections/635_egg.jpg')}" },
          { img: "#{image_path('super_collections/635_egg.jpg')}" },
          { img: "#{image_path('super_collections/635_egg.jpg')}" },
          { img: "#{image_path('super_collections/635_egg.jpg')}" },
          { img: "#{image_path('super_collections/635_egg.jpg')}" },
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
