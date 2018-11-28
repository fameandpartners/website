module AdminUi
  class ItemReturnsController < AdminUi::ApplicationController
    def index
      @collection = ItemReturnsGrid.new(params[:item_returns_grid])
      @weekly_refund = (params[:scope] == :refund_queue)

      respond_to do |f|
        f.html do
          @collection.scope do |scope|
            scope = scope.send(params[:scope]) if params[:scope]
            scope.page(params[:page]).per(50)
          end
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

    def enable_autorefund
      @item_return = ItemReturn.find(params[:item_return_id])
      order = @item_return.line_item.order
      order.autorefundable = true
      order.save!
      redirect_to item_return_path(@item_return)
    end

    def disable_autorefund
      @item_return = ItemReturn.find(params[:item_return_id])
      order = @item_return.line_item.order
      order.autorefundable = false
      order.save!
      redirect_to item_return_path(@item_return)
    end

    def generate_new_return_label
      item_return = ItemReturn.find(params[:item_return_id])
      order = Spree::Order.find_by_number(item_return.order_number)
      label = ReturnsProcessesControllerHelper.create_label(order.id)
      redirect_to label&.label_pdf_url
    end

    def bulk_refund_process
      BulkRefundWorker.perform_async(current_admin_user.email)

      redirect_to :back, notice: "Bulk refund process started"
    end

    private

    helper_method def possible_events
      ::AdminUi::ItemReturns::EventsController.event_forms.keys
    end
  end
end
