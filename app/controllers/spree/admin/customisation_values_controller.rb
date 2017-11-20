module Spree
  module Admin
    class CustomisationValuesController < ResourceController
      belongs_to 'spree/product', :find_by => :permalink

      def index
        respond_with(collection)
      end

      def update #TODO: Need to address this
        customisation_value = @product.customisation_values.find(params[:id])
        customisation_value.update_attributes(
          params[:customisation_value].reverse_merge(incompatible_ids: [])
        )
        respond_to do |format|
          format.html do
            flash[:success] = "Customisation set been updated"
            redirect_to admin_product_customisation_values_url(@product)
          end
          format.js do
            render nothing: true
          end
        end
      end

      private

      def model_class
        CustomisationValue
      end

      def collection
        parent.customisation_values.includes(:incompatibles)
      end
    end
  end
end
