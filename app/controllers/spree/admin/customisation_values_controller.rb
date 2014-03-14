module Spree
  module Admin
    class CustomisationValuesController < ResourceController
      belongs_to 'spree/product', :find_by => :permalink

      def index
        respond_with(collection)
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

      def model_class
        CustomisationValue
      end

      def collection
        parent.customisation_values
      end
    end
  end
end
