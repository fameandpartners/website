module Personalization
  class ProductsController < BaseController
    skip_before_filter :authenticate_spree_user!, only: [:index]

    respond_to :html

    require 'spree/products_helper'
    helper Spree::ProductsHelper

    def index
      @products = Spree::Product.joins(:product_customisation_values).uniq
    end

    def show
      unless spree_user_signed_in?
        return redirect_to personalization_path
      end
      
      @product = Spree::Product.joins(:product_customisation_values).uniq.active(current_currency).find_by_permalink!(params[:permalink])

      set_product_show_page_title(@product, "Custom Formal Dress ")
      @product_properties = @product.product_properties.includes(:property)

      @product_variants = Products::VariantsReceiver.new(@product).available_options

      if line_item = current_order.find_line_item_by_variant(@product.master)
        @personalization = line_item.personalization || LineItemPersonalization.new
      else
        @personalization = LineItemPersonalization.new
      end

      respond_with(@product)
    end

    private

    def colors
      @colors ||= Products::ColorsSearcher.new(@products.to_a).retrieve_colors
    end
    helper_method :colors
  end
end
