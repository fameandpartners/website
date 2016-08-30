module ManualOrder
  class ManualOrdersController < ::AdminUi::ApplicationController

    layout 'admin_ui'

    helper_method :manual_order_form

    def index
      @collection = ManualOrdersGrid.new(params[:manual_orders_grid])
      respond_to do |f|
        f.html do
          @collection.scope { |scope| scope.page(params[:page]).per(25) }
        end
        f.csv do
          send_data @collection.to_csv,
                    type: "text/csv",
                    disposition: 'inline',
                    filename: "manual_orders-#{DateTime.now.to_s(:file_timestamp)}.csv"
        end
      end
    end

    def new

    end

    def create
     if manual_order_form.validate(params[:forms_manual_order])
       manual_order_form.save { |hash| manual_order_form.save_order(hash) }

       redirect_to manual_orders_path, flash: { success: 'Order has been created successfully' }
     end
    end

    def sizes_options
      render json: manual_order_form.get_size_options(params[:product_id])
    end

    def colors_options
      render json: manual_order_form.get_color_options(params[:product_id]) | manual_order_form.get_custom_colors(params[:product_id])
    end

    def customisations_options
      render json: manual_order_form.get_customisations_options(params[:product_id])
    end

    def image
      render json: manual_order_form.get_image(params[:product_id], params[:size_id], params[:color_id])
    end

    def price
      render json: manual_order_form.get_price(params[:product_id], params[:size_id], params[:color_id], params[:currency])
    end

    def autocomplete_customers
      render json: manual_order_form.get_users_searched(params[:term])
    end

    def user_data
      render json: manual_order_form.get_user_data(params[:user_id])
    end

    private

    def manual_order_form
      @manual_order_form ||= Forms::ManualOrderForm.new(Spree::Order.new)
    end

  end
end
