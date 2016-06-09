module ManualOrder
  class ManualOrdersController < ::AdminUi::ApplicationController

    layout 'manual_order'

    helper_method :length_options_json

    def index

    end

    def new
      @manual_order_form = Forms::ManualOrderForm.new(Spree::Product.new)
    end

    def sizes_options_json
      render json: get_size_options(params[:product_id])
    end

    def colors_options_json
      render json: get_color_options(params[:product_id])
    end


    private

    def products
      Spree::Product.active
    end

    def get_size_options(product_id)
      products.find(product_id).variants.map {|v| { id: v.dress_size.id, name: v.dress_size.name} }.uniq
    end

    def get_color_options(product_id)
      products.find(product_id).variants.map {|v| { id: v.dress_color.id, name: v.dress_color.name} }.uniq
    end

    def length_options_json
      {
        'petite' =>'Petite',
        'standart' => 'Standart',
        'tall' => 'Tall'
      }
    end

  end
end
