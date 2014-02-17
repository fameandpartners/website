module Spree
  module Admin
    class ProductCustomisationsController < BaseController
      respond_to :html, :json
      before_filter :load_product

      def index
      end

      def update
        @product.update_attributes(params[:product])
        respond_to do |format|
          format.html do
            flash[:success] = "Customisation set been updated"
            redirect_to admin_product_customisation_url(@product)
          end
          format.js do
            render nothing: true
          end
        end
      end

      private

      def load_product
        @product = Spree::Product.find_by_permalink(params[:product_id])
      end
    end
  end
end
