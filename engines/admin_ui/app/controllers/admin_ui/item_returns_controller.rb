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

    # Only handles Manual Order Return Requests Right now.
    def new
      @new_return_form = Forms::ItemReturns::ManualOrderReturn.new(ItemReturnEvent.manual_order_return.build)
    end

    def create
      @new_return_form = Forms::ItemReturns::ManualOrderReturn.new(ItemReturnEvent.manual_order_return.build)
      @new_return_form.user = current_admin_user
      if @new_return_form.validate(params[:forms_item_returns_manual_order_return]) && @new_return_form.save
        redirect_to item_return_path(@new_return_form.model.item_return), notice: 'Return Created!'
      else
        render :new
      end
    end

    private

    helper_method def possible_events
      ::AdminUi::ItemReturns::EventsController.event_forms.keys
    end
  end
end
