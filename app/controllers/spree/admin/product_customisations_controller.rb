module Spree
  module Admin
    class ProductCustomisationsController < BaseController
      respond_to :html, :json
      before_filter :load_product

      private

      def load_product
        @product = Spree::Product.find_by_permalink(params[:product_id])
      end
    end
  end
end