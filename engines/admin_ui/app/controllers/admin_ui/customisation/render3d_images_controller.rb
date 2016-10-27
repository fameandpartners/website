require 'datagrid'

module AdminUi
  module Customisation
    class Render3dImagesController < AdminUi::ApplicationController

      def index
        @collection = Render3dImagesGrid.new(params[:render3d_images_grid])
        respond_to do |f|
          f.html do
            @collection.scope { |scope| scope.page(params[:page]).per(300) }
          end
          f.csv do
            send_data @collection.to_csv,
              type: "text/csv",
              disposition: 'inline',
              filename: "render3d-images-#{DateTime.now.to_s(:file_timestamp)}.csv"
          end
        end
      end

      def edit
        @render3d_image = Render3d::Image.find(params[:id])
        @page_title = "Render3d::Image - #{@render3d_image.product_id} - #{@render3d_image.color_value_id} - #{@render3d_image.customisation_value_id}"
      end

      def new
        @render3d_image = Render3d::Image.new
      end

      def create
        @render3d_image = Render3d::Image.new

        @render3d_image.tap do |img|
          img.product_id = params.fetch(:product_id)
          img.color_value_id = params.fetch(:color_value_id)
          img.customisation_value = params.fetch(:customisation_value_id, 0)
          img.attachment = params.fetch(:attachment)
        end

        if @render3d_image.save
          message = { success: <<-EOS }
            Render3d Image was successfully created for:
              [*] product:\t\t<name: #{@render3d_image.product.name}> - <sku: #{@render3d_image.product.sku}>
              [*] color:\t\t<name: #{@render3d_image.color_value.name}>
              [*] customisation:\t<name: #{@render3d_image.customisation_value.try(:name) || 'Default'}>
            EOS
          redirect_to customisation_render3d_images_path, flash: message
        else
          render :new
        end
      end

      def update
        if params[:render3d_image].blank?
          raise ArgumentError, 'No data for render3d image to update.'
        end

        @render3d_image = Render3d::Image.find(params[:id])

        params[:render3d_image].each do |key, value|
          if @render3d_image.respond_to?(key)
            @render3d_image.send(key, value)
          end
        end

        message = \
          if @render3d_image.save
            { success: <<-EOS }
              Render3d Image was successfully updated with:
                [*] product:\t\t<name: #{@render3d_image.product.name}> - <sku: #{@render3d_image.product.sku}>
                [*] color:\t\t<name: #{@render3d_image.color_value.name}>
                [*] customisation:\t<name: #{@render3d_image.customisation_value.try(:name) || 'Default'}>
              EOS
          else
            { error: @render3d_image.errors.to_json }
          end

        redirect_to customisation_render3d_images_path, flash: message
      end

      def destroy
        @render3d_image = Render3d::Image.find(params[:id])
        @render3d_image.destroy
        redirect_to customisation_render3d_images_path, flash: { success: 'Render3d Image was successfully removed' }
      end

      def collection
        @data = {
          collection: [],
          type: params[:id]
        }

        if params[:id] == ''
        end

        respond_to do |format|
          format.json { render json: @data }
        end
      end

    end
  end
end
