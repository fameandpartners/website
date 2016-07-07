module ManualOrder
  class ManualOrdersController < ::AdminUi::ApplicationController

    layout 'admin_ui'

    helper_method :manual_order_form

    def index

    end

    def new

    end

    def create
     message = if manual_order_form.save_order(params[:forms_manual_order])
                'Order has been created successfully'
               else
                'There was a problem with order saving.'
     end

     redirect_to manual_orders_path, flash: { success: message }
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
