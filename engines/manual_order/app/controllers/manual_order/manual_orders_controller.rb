module ManualOrder
  class ManualOrdersController < ::AdminUi::ApplicationController

    layout 'manual_order'

    helper_method :skirt_length_options, :site_version_options

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
      render json: get_image(params[:product_id], params[:size_id], params[:color_id])
    end

    def price_json
      render json: get_price(params[:product_id], params[:size_id], params[:color_id], params[:currency])
    end

    private

    def products
      Spree::Product.active
    end

    def get_size_options(product_id)
      products.find(product_id).variants.map {|v| { id: v.dress_size.id, name: v.dress_size.name} }.uniq
    end

    def get_color_options(product_id)
      products.find(product_id).variants
        .map {|v| { id: v.dress_color.id, name: v.dress_color.presentation, type: 'color'} }.uniq
    end

    def get_custom_colors(product_id)
      custom_colors = products.find(product_id).product_color_values.where(custom: true).pluck(:option_value_id)
      Spree::OptionValue.colors.where('id IN (?)', custom_colors)
        .map {|c| { id: c.id, name: "#{c.presentation} (+ $16.00)", type: 'custom' } }.uniq
    end

    def get_customisations_options(product_id)
      products.find(product_id).customisation_values
        .map {|c| { id: c.id, name: "#{c.presentation} (+ $#{c.price})" } }
    end

    def get_image(product_id, size_id, color_id)
      variant = get_variant(product_id, size_id, color_id)
      url = if variant.present? && variant_image(variant).try(:attachment).present?
              variant_image(variant).attachment.url(:large)
            else
              'null'
            end
      { url: url }
    end

    def get_price(product_id, size_id, color_id, currency = 'USD')
      price = get_variant(product_id, size_id, color_id).get_price_in(currency)
      { price: price.amount, currency: currency }
    end

    def get_variant(product_id, size_id, color_id)
      size_variants = if size_id.to_i > 0
                        Spree::OptionValue.find(size_id).variants
                          .where(product_id: product_id, is_master: false).pluck(:id)
                      else
                        nil
                      end
      color_variants = Spree::OptionValue.find(color_id).variants
                         .where(product_id: product_id, is_master: false).pluck(:id)
      variant_ids = if size_variants.present? && color_variants.present?
                      size_variants & color_variants
                    elsif color_variants.present?
                      color_variants
                    else
                      size_variants
                    end
      Spree::Variant.where(id: variant_ids).first
    end

    def variant_image(variant)
      cropped_images_for(variant.product.images_for_variant(variant))
    end

    def cropped_images_for(image_set)
      image_set.select { |i| i.attachment.url(:large).downcase.include?('front-crop') }.first
    end

    def site_version_options
      {
        'USD' =>'USA',
        'AUD' => 'Australia'
      }
    end

    def skirt_length_options
      {
        'petite' =>'Petite',
        'standart' => 'Standart',
        'tall' => 'Tall'
      }
    end

  end
end
