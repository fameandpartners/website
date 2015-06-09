module Admin
  module FabricCards
    class ProductsController < Spree::Admin::BaseController
      def show
        @product = Spree::Product.find_by_permalink(params[:id])

        @product_template = ::Importers::SkuGeneration::ProductTemplate.new(
          @product.sku,
          @product.name
        )

        @product_template.fabric_card = FabricCard.hydrated.find(params[:fabric_card_id])
      end
    end
  end
end
