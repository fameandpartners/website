module AdminUi
  module Reports
    class RefundsController < AdminUi::ApplicationController
      def show
        @collection = RefundGrid.new(params[:refund_grid])

        respond_to do |f|
          f.html do
            @collection.scope { |scope| scope.page(params[:page]) }
          end
          f.csv do
            send_data @collection.to_csv,
                      type:        'text/csv',
                      disposition: 'inline',
                      filename:    "return_requests-#{DateTime.now.to_s(:file_timestamp)}.csv"
          end
        end
      end
    end
  end
end

