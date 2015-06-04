module Spree
  module Admin
    class ProductColorsController < BaseController
      before_filter :load_product, :load_option_types

      def new
      end

      def create
        Products::ColourVariantGenerator.new(product: @product).create_variants(params[:sizes], params[:colors])

        flash.notice = 'Variants successfully added'
        redirect_to admin_product_variants_path(@product)
      end

      private

      def load_product
        @product = Spree::Product.find(params[:product_id])
      end

      def load_option_types
        @color_option = Spree::OptionType.where(name: 'dress-color').first
        @size_option  = Spree::OptionType.where(name: 'dress-size').first
      end
    end
  end
end
