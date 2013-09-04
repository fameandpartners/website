module Spree
  module Admin
    class ProductPositionsController < BaseController
      def show
        @collection = Product.active.ordered.group_by_products_id.includes(:taxons).to_a
      end

      def create
        # add ability to sort inside taxon
        params[:positions].each do |id, index|
          Spree::Product.where(:id => id).update_all(:position => index)
        end
      end
    end
  end
end
