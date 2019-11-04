require 'datagrid'

module AdminUi
    class MakingOptionsController < AdminUi::ApplicationController
      def index
        @collection = MakingOptionGrid.new(params[:making_option_grid])
        respond_to do |f|
          f.html do
            @collection.scope { |scope| scope.page(params[:page]) }
          end
          f.csv do
            send_data @collection.to_csv,
              type: "text/csv",
              disposition: 'inline',
              filename: "making_options-#{DateTime.now.to_s(:file_timestamp)}.csv"
          end
        end
      end

      def new
        @form = Forms::MakingOptionForm.new(MakingOption.new)
      end

      def create
        @form = Forms::MakingOptionForm.new(MakingOption.new)
        if @form.validate(params[:forms_making_option]) && @form.save
          message = { success: "Make option '#{@form.model.code}' successfully created" }
          redirect_to edit_making_option_path(@form.model), flash: message
        else
          render :new
        end
      end

      def show
        @form = Forms::MakingOptionForm.new(MakingOption.find(params[:id]))
      end

      def edit
        @form = Forms::MakingOptionForm.new(MakingOption.find(params[:id]))
      end

      def update
        @making_option = MakingOption.find(params[:id])
        @form = Forms::MakingOptionForm.new(@making_option)
        if @form.validate(params[:forms_making_option]) && @form.save
          message = { success: "Make Option '#{@making_option.code}' sucessfully updated"}
          redirect_to making_options_path, flash: message
        else
          render :edit
        end
      end
    end
end
