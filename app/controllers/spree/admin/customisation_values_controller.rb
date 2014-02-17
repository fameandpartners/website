module Spree
  module Admin
    class CustomisationValuesController < BaseController
      def index
        @customisation_values = CustomisationValue.ordered
      end

      def new
        @customisation_value = CustomisationValue.new
      end

      def create
        @customisation_value = CustomisationValue.new(params[:customisation_value])
        if @customisation_value.save
          flash[:success] = 'Customisation value successfully created'
          redirect_to action: :index
        else
          render action: :new
        end
      end

      def edit
        @customisation_value = CustomisationValue.find(params[:id])
      end

      def update
        @customisation_value = CustomisationValue.find(params[:id])
        if @customisation_value.update_attributes(params[:customisation_value])
          flash[:success] = 'Customisation value has been successfully updated.'
          redirect_to action: :index
        else
          render action: :edit
        end
      end

      def update_positions
        params[:positions].each do |id, index|
          CustomisationValue.update_all({ position: index }, {id: id})
        end
        render nothing: true
      end

      def destroy
        @customisation_value = CustomisationValue.where(id: params[:id]).first
        if @customisation_value
          @customisation_value.try(:destroy)
        end
      end

      private 

      def model_class
        ::CustomisationValue
      end
    end
  end
end
=begin
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
=end
