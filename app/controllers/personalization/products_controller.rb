module Personalization
  class ProductsController < BaseController
    respond_to :html

    require 'spree/products_helper'
    helper Spree::ProductsHelper

    def index
      @products = Spree::Product.active.joins(:customisation_values).uniq
    end

    def show
      @product = Spree::Product.joins(:customisation_values).uniq.active(Spree::Config.currency).find_by_permalink!(params[:permalink])

      set_product_show_page_title(@product, "Custom Formal Dress ")
      @product_properties = @product.product_properties.includes(:property)

      @product_variants = Products::VariantsReceiver.new(@product).available_options
      @recommended_products = get_recommended_products(@product, limit: 3)

      if line_item = current_order.find_line_item_by_variant(@product.master)
        @personalization = line_item.personalization || LineItemPersonalization.new
      else
        @personalization = LineItemPersonalization.new
      end

      respond_with(@product)
    end

    def style
      @product = Spree::Product.active(Spree::Config.currency).find_by_permalink!(params[:permalink])

      set_product_show_page_title(@product, "Custom Formal Dress ")
      @product_properties = @product.product_properties.includes(:property)
      @product_variants = Products::VariantsReceiver.new(@product).available_options

      @recommended_products = get_recommended_products(@product, limit: 3)

      respond_with(@product)
    end

    private

    def colors
      @colors ||= Products::ColorsSearcher.new(@products.to_a).retrieve_colors
    end
    helper_method :colors
  end
end
