module Spree
  module Admin
    class ProductCustomisationValuesController < BaseController
      respond_to :json

      def model_class
        ProductCustomisationValue
      end

      def destroy
        Spree::Product.find_by_permalink(params[:product_id]).product_customisation_values.find_by_id(params[:id]).delete
        render nothing: true, status: :ok
      end
    end
  end
end