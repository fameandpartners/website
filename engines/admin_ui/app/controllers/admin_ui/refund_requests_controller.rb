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
  end
end
