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

    def sizes_options_json
      render json: manual_order_form.get_size_options(params[:product_id])
    end

    def colors_options_json
      render json: manual_order_form.get_color_options(params[:product_id]) | manual_order_form.get_custom_colors(params[:product_id])
    end

    def customisations_options_json
      render json: manual_order_form.get_customisations_options(params[:product_id])
    end

    def image_json
      render json: manual_order_form.get_image(params[:product_id], params[:size_id], params[:color_id])
    end

    def price_json
      render json: manual_order_form.get_price(params[:product_id], params[:size_id], params[:color_id], params[:currency])
    end

    def autocomplete
      render json: manual_order_form.get_users_searched(params[:term]).limit(10).map {|u| {id: u.id, value: u.full_name}}
    end

    def user_data
      render json: manual_order_form.get_user_data(params[:user_id])
    end

    private

    def manual_order_form
      @manual_order_form ||= Forms::ManualOrderForm.new(Spree::Product.new)
    end

    def customers
      user_ids = Spree::Order.complete.pluck(:user_id).uniq
      @customers ||= Spree::User.where(id: user_ids)
                       .limit(10).map {|u| [u.id, u.full_name]}
    end

  end
end
