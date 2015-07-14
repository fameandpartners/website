module AdminUi
  class ItemReturnsController < AdminUi::ApplicationController
    def index
      @collection = ItemReturnsGrid.new(params[:item_returns_grid]) do |scope|
        scope.page(params[:page]).per(50)
      end
    end

    def show
      @item_return = ItemReturn.find(params[:id])
      @page_title = "Return - #{@item_return.order_number} - #{@item_return.line_item_id} - #{@item_return.contact_email}"
    end

    private

    helper_method def possible_events
      [:receive_item]
    end
  end
end
