module AdminUi
  class ItemReturnsController < AdminUi::ApplicationController
    def index
      @collection = ItemReturn.all
    end

    def show
      @item_return = ItemReturn.find(params[:id])
    end
  end
end
