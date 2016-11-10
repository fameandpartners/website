module AdminUi
  module Logistics
    class NextController < ::AdminUi::ApplicationController
      def index
        @collection = ::Logistics::NextProcessGrid.new(params[:logistics_next_process_grid])
        respond_to do |f|
          f.html do
            @collection.scope { |scope| scope.page(params[:page]) }
          end
          f.csv do
            send_data @collection.to_csv,
                      type:        'text/csv',
                      disposition: 'inline',
                      filename:    "next_logistics-#{DateTime.now.to_s(:file_timestamp)}.csv"
          end
        end
      end

      def retry
        @return_request_process = NextLogistics::ReturnRequestProcess.find(params[:id])

        @return_request_process.failed = false
        @return_request_process.save!

        redirect_to admin_ui.logistics_next_index_path, notice: t('next_logistics.retrying_message', id: @return_request_process.id)
      end
    end
  end
end
