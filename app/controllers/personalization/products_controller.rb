module Personalization
  class ProductsController < BaseController
    before_filter :check_presence_of_settings

    respond_to :html

    require 'spree/products_helper'
    helper Spree::ProductsHelper

    def index
      @products = Spree::Product.joins(:product_customisation_values).uniq
    end

    def show
      @product = Spree::Product.active(current_currency).find_by_permalink!(params[:permalink])

      set_product_show_page_title(@product)
      @product_properties = @product.product_properties.includes(:property)

      @similar_products = Products::SimilarProducts.new(@product).fetch(4)
      @product_variants = Products::VariantsReceiver.new(@product).available_options

      if line_item = current_order.find_line_item_by_variant(@product.master)
        @personalization = line_item.personalization || LineItemPersonalization.new
      else
        @personalization = LineItemPersonalization.new
      end

      respond_with(@product)
    end

    private

    def check_presence_of_settings
      unless current_spree_user.personalization_settings.present?
        redirect_to edit_personalization_settings_path
      end
    end

    def colors
      @colors ||= Products::ColorsSearcher.new(@products.to_a).retrieve_colors
    end
    helper_method :colors
  end
end
