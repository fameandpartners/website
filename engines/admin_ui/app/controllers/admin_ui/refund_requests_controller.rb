module AdminUi
  class RefundRequestsController < AdminUi::ApplicationController
    def index
      @collection = RefundRequestGrid.new(params[:refund_request_grid])

      respond_to do |f|
        f.html do
          @collection.scope { |scope| scope.page(params[:page]).per(300) }
        end
        f.csv do
          send_data @collection.to_csv,
                    type:        "text/csv",
                    disposition: 'inline',
                    filename:    "refund_requests-#{DateTime.now.to_s(:file_timestamp)}.csv"
        end
      end
    end

    def update
      @refund_request = RefundRequest.find(params[:id])

      if @refund_request.refundable?
        message = "Refunding!"
        @refund_request.refund!
      else
        message = "No Change."
        @refund_request.refresh_refund_status
      end

      @refund_request.save!

      redirect_to refund_requests_path, notice: message
    end
  end
end
