module AdminUi
  class ManuallyManagedReturnsController < AdminUi::ApplicationController
    def index

      @collection = ManuallyManagedReturnGrid.new(params[:manually_managed_return_grid])
      respond_to do |f|
        f.html do
          @collection.scope { |scope| scope.page(params[:page]).per(50) }
        end
        f.csv do
          send_data @collection.to_csv,
            type: "text/csv",
            disposition: 'inline',
            filename: "manually_managed_returns-#{DateTime.now.to_s(:file_timestamp)}.csv"
        end
      end
    end

    def show
      if params[:id]
        @resource = ManuallyManagedReturn.find(params[:id])
      end
    end
  end
end
