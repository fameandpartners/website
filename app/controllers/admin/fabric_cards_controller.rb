module Admin
  class FabricCardsController < Spree::Admin::BaseController

    skip_before_filter :check_site_version

    attr_reader :collection, :fabric_card
    helper_method :collection, :fabric_card

    def index
      @table = FabricCardGrid.new cards: collection, colours: FabricColour.all
    end

    def show

    end

    private

    def collection
      @collection ||= model_class.includes(:fabric_card_colours => :fabric_colour).all
    end

    def fabric_card
      @fabric_card ||= model_class.find(params[:id])
    end


    # Spree compatibility
    def model_class
      ::FabricCard
    end
  end
end
