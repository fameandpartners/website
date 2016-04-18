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

    def new
      @product_color_value = ProductColorValue.new
    end

    def create
      @product_color_value = ProductColorValue.new(params[:product_color_value])
      if @product_color_value.valid?
        @product_color_value.save!
        message = { success: "Color '#{@product_color_value.option_value.name}'
                    for the product '#{@product_color_value.product.name}' successfully created" }
        redirect_to product_colors_path, flash: message
      else
        render :new
      end
    end

    def edit
      @product_color_value = ProductColorValue.find(params[:id])
    end

    def update
      @product_color_value = ProductColorValue.find(params[:id])

      if @product_color_value.update_attributes!(params[:product_color_value])
        color_state = @product_color_value.active? ? 'Active' : 'Inactive'
        message = { success: "Color '#{@product_color_value.option_value.name}'
                    for the product '#{@product_color_value.product.name}' is now #{color_state}" }
      else
        message = { error: 'A problem occurred on saving. Please try again later.' }
      end

      redirect_to product_colors_path, flash: message
    end

    def colors_options_json
      render json: get_color_options(params[:product_id]).map { |c| {id: c.id, name: c.name} }
    end

  private

    helper_method :products, :color_options

    def products
      Spree::Product.active
    end

    def color_options
      get_color_options(params[:product_color_value].try(:[], :product_id))
    end

    def get_color_options(product_id)
      if product_id.present?
        option_values_ids = Spree::Product.find(product_id).product_color_values.pluck(:option_value_id)
        Spree::OptionValue.colors.where(Spree::OptionValue.arel_table[:id].not_in(option_values_ids))
      else
        {}
      end
    end

  end
end
