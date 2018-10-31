module Admin
  class FabricCardsController < Spree::Admin::BaseController

    attr_reader :collection, :fabric_card
    helper_method :collection, :fabric_card

    def index
      @table = FabricCardGrid.new cards: collection, colours: FabricColour.all
    end

    def show
      # NOOP
    end

    private

    def collection
      @collection ||= model_class.hydrated.all
    end

    def fabric_card
      @fabric_card ||= model_class.hydrated.find(params[:id])
    end

    # Spree compatibility
    def model_class
      ::FabricCard
    end
  end
end
