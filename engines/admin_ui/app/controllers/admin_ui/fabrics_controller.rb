require 'datagrid'

module AdminUi
    class FabricsController < AdminUi::ApplicationController

      before_filter :set_color_taxons

      def index
        @collection = FabricGrid.new(params[:fabric_grid])
        respond_to do |f|
          f.html do
            @collection.scope { |scope| scope.page(params[:page]) }
          end
          f.csv do
            send_data @collection.to_csv,
              type: "text/csv",
              disposition: 'inline',
              filename: "fabrics-#{DateTime.now.to_s(:file_timestamp)}.csv"
          end
        end
      end

      def new
        @form = Forms::FabricForm.new(Fabric.new)
      end

      def create
        @form = Forms::FabricForm.new(Fabric.new)
        if @form.validate(params[:forms_fabric])
          @form.save do |hash|
            hash["taxon_ids"] = [] unless params["forms_fabric"]["taxon_ids"]
            hash["image"] = nil unless params["forms_fabric"]["image"]
            @form.model.update_attributes(hash)
          end
          message = { success: "Fabric '#{@form.model.name}' successfully created" }
          redirect_to edit_fabric_path(@form.model), flash: message
        else
          render :new
        end
      end

      def show
        @form = Forms::FabricForm.new(Fabric.find(params[:id]))
      end

      def edit
        @form = Forms::FabricForm.new(Fabric.find(params[:id]))
      end

      def update
        @fabric = Fabric.find(params[:id])
        @form = Forms::FabricForm.new(@fabric)
        if @form.validate(params[:forms_fabric])
          @form.save do |hash|
            hash["taxon_ids"] = [] unless params["forms_fabric"]["taxon_ids"]
            hash["image"] = nil unless params["forms_fabric"]["image"]
            @form.model.update_attributes(hash)
          end
          message = { success: "Fabric '#{@fabric.presentation}' sucessfully updated"}
          redirect_to fabrics_path, flash: message
        else
          render :edit
        end
      end

      def set_color_taxons
        @color_taxons = Spree::Taxon.where("permalink ilike 'color/%'")
      end
    end
end
