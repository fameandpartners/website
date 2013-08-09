class ProductVariantsController < ApplicationController
  # get product info + variants details[exclude master]
  #   id [product_id]
  #   variant_id
  def show
    object = nil

    if params[:id] || params[:product_id]
      product = Spree::Product.find(params[:id] || params[:product_id])
    elsif params[:variant_id]
      variant = Spree::Variant.find(params[:variant_id])
      product = variant.product
    else
      raise "can't find something without id"
    end

    @product_variants = Products::VariantsReceiver.new(product.id).available_options

    render json: {
      variants: @product_variants,
      product: ProductSerializer.new(product)
    }
  end
end
