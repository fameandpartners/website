module ManualOrder
  class ManualOrdersController < ::AdminUi::ApplicationController

    layout 'admin_ui'

    helper_method :manual_order_form, :customers

    def index

    end

    def new

    end

    def create
      render 'new'
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

    def autocomplete
      render json: manual_order_form.get_users_searched(params[:term]).limit(10).map {|u| {id: u.id, value: u.full_name}}
    end

    private

    def manual_order_form
      @manual_order_form ||= Forms::ManualOrderForm.new(Spree::Product.new)
    end

    def customers
      @customers ||= Spree::User.registered.limit(10).map {|u| [u.id, u.full_name]}
    end

  end
end
