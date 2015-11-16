require 'datagrid'

module AdminUi
  class ProductColorsController < AdminUi::ApplicationController
    def index
      @collection = ProductColorValuesGrid.new(params[:product_color_values_grid])
      respond_to do |f|
        f.html do
          @collection.scope { |scope| scope.page(params[:page]).per(50) }
        end
        f.csv do
          send_data @collection.to_csv,
            type: "text/csv",
            disposition: 'inline',
            filename: "product_color_values-#{DateTime.now.to_s(:file_timestamp)}.csv"
        end
      end
    end
  end
end
