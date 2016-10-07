module AdminUi
  module Logistics
    class BergenController < ::AdminUi::ApplicationController
      def index
        @collection = BergenProcessGrid.new(params[:bergen_process_grid])
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
    end
  end
end
