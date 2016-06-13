module ManualOrder
  class ManualOrdersController < ::AdminUi::ApplicationController

    layout 'manual_order'

    helper_method :length_options

    def index

    end

    def new
      @manual_order_form = Forms::ManualOrderForm.new(Spree::Product.new)
    end

    def sizes_options_json
      render json: get_size_options(params[:product_id])
    end

    def colors_options_json
      render json: get_color_options(params[:product_id]) | get_custom_colors(params[:product_id])
    end

    def customisations_options_json
      render json: get_customisations_options(params[:product_id])
    end

    private

    def products
      Spree::Product.active
    end

    def get_size_options(product_id)
      products.find(product_id).variants.map {|v| { id: v.dress_size.id, name: v.dress_size.name} }.uniq
    end

    def get_color_options(product_id)
      products.find(product_id).variants.map {|v| { id: v.dress_color.id, name: v.dress_color.name, type: 'color'} }.uniq
    end

    def get_custom_colors(product_id)
      custom_colors = products.find(product_id).product_color_values.where(custom: true).pluck(:option_value_id)
      Spree::OptionValue.colors.where('id IN (?)', custom_colors).map {|c| { id: c.id, name: c.name, type: 'custom' } }.uniq
    end

    def get_customisations_options(product_id)
      products.find(product_id).customisation_values.map {|c| { id: c.id, name: "#{c.presentation} (#{c.price})"} }
    end

    def length_options
      {
        'petite' =>'Petite',
        'standart' => 'Standart',
        'tall' => 'Tall'
      }
    end

  end
end
