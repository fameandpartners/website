require 'datagrid'

module AdminUi
  module Customisation
    class CustomisationValuesController < AdminUi::ApplicationController

      def index
        @collection = CustomisationValuesGrid.new(params[:customisation_values_grid])
        respond_to do |f|
          f.html do
            @collection.scope { |scope| scope.page(params[:page]) }
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
        @form = Forms::CustomisationValueForm.new(CustomisationValue.new)
      end

      def create
        @form = Forms::CustomisationValueForm.new(CustomisationValue.new)
        if @form.validate(params[:forms_customisation_value])
          @form.save
          message = { success: "Customisation Value '#{@form.model.name}' successfully created" }
          redirect_to edit_customisation_customisation_value_path(@form.model), flash: message
        else
          render :new
        end
      end

      def edit
        @form = Forms::CustomisationValueForm.new(CustomisationValue.find(params[:id]))
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
        CustomisationValue.find(params[:id]).destroy
        redirect_to customisation_customisation_values_path, flash: { success: 'Customisation value successfully removed' }
      end

      def option_values
        product = Spree::Product.find_by_id params[:product_id]
        product_options = Products::SelectionOptions.new(product: product).read
        customizations = product_options[:customizations][:all].map { |p| { id: p.id, name: p.name } }
        render json: customizations
      end
    end
  end
end
