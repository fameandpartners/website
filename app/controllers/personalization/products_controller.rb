module Personalization
  class ProductsController < BaseController
    respond_to :html

    require 'spree/products_helper'
    helper Spree::ProductsHelper

    def index
      @products = Spree::Product.active.joins(:customisation_values).uniq
    end

    def show
      if params[:product_id]
        @product = Spree::Product.joins(:customisation_values).uniq.active(Spree::Config.currency).find(params[:product_id])
      else
        @product = Spree::Product.joins(:customisation_values).uniq.active(Spree::Config.currency).find_by_permalink(params[:permalink])
      end

      # check and redirect if needed
      ensure_customization_available(@product) and return

      set_product_show_page_title(@product, "Custom Formal Dress ")
      display_marketing_banner

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
      if params[:product_id]
        @product = Spree::Product.active(Spree::Config.currency).find(params[:product_id])
      else
        @product = Spree::Product.active(Spree::Config.currency).find_by_permalink!(params[:permalink])
      end

      set_product_show_page_title(@product, "Style your formal dress ")
      display_marketing_banner

      @product_properties = @product.product_properties.includes(:property)
      @product_variants = Products::VariantsReceiver.new(@product).available_options

      @recommended_products = get_recommended_products(@product, limit: 3)

      respond_with(@product)
    end

    private

    def ensure_customization_available(product)
      if product.blank?
        redirect_to(collection_path)
      elsif !product.can_be_customized? or product.in_sale?
        redirect_to view_context.collection_product_path(product)
      else
        # all ok, do nothing
        return false
      end
    end

    def colors
      @colors ||= Products::ColorsSearcher.new(@products.to_a).retrieve_colors
    end
    helper_method :colors

    def incompatibility_map(product = @product)
      result = {}
      product.customisation_values.includes(:incompatibilities).each do |customisation_value|
        result[customisation_value.id] = customisation_value.incompatibilities.map(&:incompatible_id)
      end
      result
    end
    helper_method :incompatibility_map
  end
end
