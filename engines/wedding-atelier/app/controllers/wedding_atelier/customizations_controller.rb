require_dependency "wedding_atelier/application_controller"
module WeddingAtelier
  class CustomizationsController < ApplicationController

    def index
      @products = Spree::Taxon.find_by_permalink('base-silhouette').products
      @fabrics = Spree::OptionType.find_by_name('wedding-atelier-fabrics').option_values
      @colours = Spree::OptionType.find_by_name('wedding-atelier-colors').option_values
      @lengths = Spree::OptionType.find_by_name('wedding-atelier-lengths').option_values
      @sizes = Spree::OptionType.find_by_name('dress-size').option_values
      @assistants = WeddingAtelier::Event.find_by_slug(params[:event_id]).assistants
      @heights = WeddingAtelier::Height.definitions
      @customization = Customization.new({
        silhouettes: @products,
        fabrics: @fabrics,
        colours: @colours,
        lengths: @lengths,
        sizes: @sizes,
        assistants: @assistants,
        heights: @heights
      })
      render json: @customization

    end
  end
end
