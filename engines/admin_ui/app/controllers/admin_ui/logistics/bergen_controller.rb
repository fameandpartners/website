module AdminUi
  module Logistics
    class BergenController < ::AdminUi::ApplicationController
      def index
        puts("one time ==============================================================================================")
        @collection = ::Logistics::BergenProcessGrid.new(params[:logistics_bergen_process_grid])
        respond_to do |f|
          f.html do
            @collection.scope { |scope| scope.page(params[:page]) }
          end
          f.csv do
            send_data @collection.to_csv,
                      type:        'text/csv',
                      disposition: 'inline',
                      filename:    "bergen_process-#{DateTime.now.to_s(:file_timestamp)}.csv"
          end
        end
      end

      def retry
        @return_item_process = Bergen::Operations::ReturnItemProcess.find(params[:id])

        @return_item_process.failed = false
        @return_item_process.save!

        redirect_to admin_ui.logistics_bergen_index_path, notice: t('bergen.retrying_message', id: @return_item_process.id)
      end
    end
  end
end
