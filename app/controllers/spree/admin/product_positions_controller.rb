module Spree
  module Admin
    class ProductPositionsController < BaseController
      def show
        @collection = Product.active.ordered.group_by_products_id.includes(:taxons).to_a
      end

      def create
        # add ability to sort inside taxon
        params[:positions].each do |id, index|
          product = Spree::Product.find_by_id(id)
          product.update_column(:position, index)
          product.update_index
        end
      end
    end
  end
end
