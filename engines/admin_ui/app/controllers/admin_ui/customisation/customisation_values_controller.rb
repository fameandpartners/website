require 'datagrid'

module AdminUi
  module Customisation
    class CustomisationValuesController < AdminUi::ApplicationController

      def index
        @collection = CustomisationValuesGrid.new
        respond_to do |f|
          f.html do
            @collection.scope { |scope| scope.page(params[:page]).per(100) }
          end
          f.csv do
            send_data @collection.to_csv,
              type: "text/csv",
              disposition: 'inline',
              filename: "customisation_values-#{DateTime.now.to_s(:file_timestamp)}.csv"
          end
        end
      end

      def new
        @customisation_value = CustomisationValue.new
        @form = Forms::CustomisationValueForm.new(@customisation_value)
        @customisation_types = CustomisationValue::AVAILABLE_CUSTOMISATION_TYPES
        @products = Spree::Product.active
      end

      def create
        @form = Forms::CustomisationValueForm.new(CustomisationValue.new)
        if @form.validate(params[:forms_customisation_value])
          @form.save
          message = { success: "Customisation Value '#{@form.model.name}' successfully created" }
          redirect_to edit_customisation_customisation_value_path(@form.model), flash: message
        else
          @products = Spree::Product.active
          @customisation_types = CustomisationValue::AVAILABLE_CUSTOMISATION_TYPES
          render :new
        end
      end

      def edit
        @customisation_value = CustomisationValue.find(params[:id])
        @form = Forms::CustomisationValueForm.new(@customisation_value)
        @customisation_types = CustomisationValue::AVAILABLE_CUSTOMISATION_TYPES
        @products = Spree::Product.active
      end

      def update
        @customisation_value = CustomisationValue.find(params[:id])
        @form = Forms::CustomisationValueForm.new(@customisation_value)
        if @form.validate(params[:forms_customisation_value])
          @form.save
          message = { success: "Customisation value '#{@customisation_value.presentation}' sucessfully updated"}
          redirect_to customisation_customisation_values_path, flash: message
        else
          render :edit
        end
      end

      def destroy
        @customisation_value = CustomisationValue.find(params[:id])
        @customisation_value.destroy
        redirect_to customisation_customisation_values_path, flash: { success: 'Customisation value successfully removed' }
      end
    end
  end
end
