module Spree
  module Admin
    class ProductCustomisationTypesController < BaseController
      respond_to :json

      def model_class
        ProductCustomisationType
      end

      def destroy
        Spree::Product.find_by_permalink(params[:product_id]).product_customisation_types.find_by_id(params[:id]).delete
        render nothing: true, status: :ok
      end
    end
  end
end