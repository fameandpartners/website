module AdminUi
  module Reports
    class SizeNormalisationsController < AdminUi::ApplicationController
      def show
        @collection = SizeNormalisationsGrid.new(params[:item_returns_grid])
        respond_to do |f|
          f.html do
            @collection.scope { |scope| scope.page(params[:page]).per(100) }
          end
          f.csv do
            send_data @collection.to_csv,
              type: "text/csv",
              disposition: 'inline',
              filename: "item_returns-#{DateTime.now.to_s(:file_timestamp)}.csv"
          end
        end
      end
    end
  end
end
