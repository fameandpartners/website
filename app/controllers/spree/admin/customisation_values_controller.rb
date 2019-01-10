module Spree
  module Admin
    class CustomisationValuesController < ResourceController
      belongs_to 'spree/product', :find_by => :permalink

      def index
        respond_with(collection)
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
