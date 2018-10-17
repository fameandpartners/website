module Spree
  module Admin
    class ProductPositionsController < BaseController
      def show
        @collection = Product.active.ordered.group_by_products_id.includes(:master, :taxons).to_a
      end

      def create
        #params[:positions].each_with_index do |id, position|
        #  product = Spree::Product.find_by_id(id)
        #  if product.present?
        #    product.position = position
        #    product.save
        #  end
        #end
        params[:positions].each do |id, position|
          Spree::Product.update_all({ position: position }, {id: id})
        end

        render nothing: true
      end

      # update changes
      def update
        Utility::Reindexer.reindex

        render nothing: true
      end
    end
  end
end
