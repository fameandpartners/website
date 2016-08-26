module AdminUi
  class ReturnRequestsReportsController < AdminUi::ApplicationController
    def index
      @collection = ReturnRequestReportGrid.new(params[:return_request_report_grid])

      respond_to do |f|
        f.html do
          @collection.scope { |scope| scope.page(params[:page]).per(300) }
        end
        f.csv do
          send_data @collection.to_csv,
                    type:        "text/csv",
                    disposition: 'inline',
                    filename:    "return_requests-#{DateTime.now.to_s(:file_timestamp)}.csv"
        end
      end
    end
  end
end

