module Spree
  module Admin
    class CustomisationValuesController < BaseController
      def model_class
        CustomisationValue
      end

      def destroy
        customisation_value = CustomisationValue.find(params[:id])
        customisation_value.destroy
        render :text => nil
      end
    end
  end
end
