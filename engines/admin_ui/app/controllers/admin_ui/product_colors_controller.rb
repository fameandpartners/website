require 'datagrid'

module AdminUi
  class ProductColorsController < AdminUi::ApplicationController
    def index
      @collection = ProductColorValuesGrid.new(params[:product_color_values_grid])
      respond_to do |f|
        f.html do
          @collection.scope { |scope| scope.page(params[:page]).per(100) }
        end
        f.csv do
          send_data @collection.to_csv,
            type: "text/csv",
            disposition: 'inline',
            filename: "product_color_values-#{DateTime.now.to_s(:file_timestamp)}.csv"
        end
      end
    end

    def edit
      @product_color_value = ProductColorValue.find(params[:id].to_i)
    end

    def update
      @product_color_value = ProductColorValue.find(params[:id].to_i)

      message = { error: 'A problem occurred saving.' }

      if new_active_state = params[:product_color_value][:active]

        @product_color_value.active = ActiveRecord::ConnectionAdapters::Column.value_to_boolean(new_active_state)
        @product_color_value.custom = params[:product_color_value][:custom]

        if @product_color_value.save
          new_state = @product_color_value.active? ? 'active' : 'inactive'

          message = { success: "Product Color is now (#{new_state})" }
        end
      end

      redirect_to product_colors_path, flash: message
    end
  end
end
