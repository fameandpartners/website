module AdminUi
  class ItemReturnsController < AdminUi::ApplicationController
    def index
      @ir = ItemReturn.last

      @collection = ItemReturnsGrid.new(params[:item_returns_grid]) do |scope|
        scope.page(params[:page]).per(50)
      end
    end

    def show
      @item_return = ItemReturn.find(params[:id])
    end


    def receive

    end
  end
end
