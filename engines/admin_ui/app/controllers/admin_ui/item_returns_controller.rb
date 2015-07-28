module AdminUi
  class ItemReturnsController < AdminUi::ApplicationController
    def index
      @collection = ItemReturnsGrid.new(params[:item_returns_grid])
      respond_to do |f|
        f.html do
          @collection.scope { |scope| scope.page(params[:page]).per(50) }
        end
        f.csv do
          send_data @collection.to_csv,
            type: "text/csv",
            disposition: 'inline',
            filename: "item_returns-#{DateTime.now.to_s(:file_timestamp)}.csv"
        end
      end
    end

    def show
      @item_return = ItemReturn.find(params[:id])
      @page_title = "Return - #{@item_return.order_number} - #{@item_return.line_item_id} - #{@item_return.contact_email}"
    end

    private

    helper_method def possible_events
      [:receive_item, :approve]
    end
  end
end
