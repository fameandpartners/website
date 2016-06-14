module ManualOrder
  class ManualOrdersController < ::AdminUi::ApplicationController

    layout 'manual_order'

    helper_method :length_options

    def index

    end

    def new
      @manual_order_form = Forms::ManualOrderForm.new(Spree::Product.new)
    end

    def create
      @manual_order_form = Forms::ManualOrderForm.new(Spree::Product.new)
      render 'new'
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

    def image_json
      render json: get_image_json(params[:product_id], params[:size_id], params[:color_id])
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

    def get_image_json(product_id, size_id, color_id)
      size_variants = Spree::OptionValue.find(size_id).variants.where(product_id: product_id, is_master: false).pluck(:id)
      color_variants = Spree::OptionValue.find(color_id).variants.where(product_id: product_id, is_master: false).pluck(:id)
      variant = Spree::Variant.find (size_variants | color_variants).first
      { url: variant_image(variant).try(:attachment).try(:url, :large) }
    end

    def variant_image(variant)
      cropped_images_for(variant.product.images_for_variant(variant))
    end

    def cropped_images_for(image_set)
      image_set.select { |i| i.attachment.url(:large).downcase.include?('front-crop') }.first
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
