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
      @product_color_value = ProductColorValue.find(params[:id])
    end

    def update
      @product_color_value = ProductColorValue.find(params[:id])
      @product_color_value.tap do |p|
        p.active = ActiveRecord::ConnectionAdapters::Column.value_to_boolean(params[:product_color_value][:active])
        p.custom = ActiveRecord::ConnectionAdapters::Column.value_to_boolean(params[:product_color_value][:custom])
      end

      if @product_color_value.save
        new_state = @product_color_value.active? ? 'active' : 'inactive'
        message = { success: "Product Color is now (#{new_state})" }
      else
        message = { error: 'A problem occurred on saving. Please try again later.' }
      end

      redirect_to product_colors_path, flash: message
    end

  end
end
