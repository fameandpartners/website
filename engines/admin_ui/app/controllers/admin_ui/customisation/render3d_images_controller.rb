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
        @initial_attrs  = {
          product: { id: @render3d_image.product_id, text: @render3d_image.product.name_with_sku },
          color_value: { id: @render3d_image.color_value_id, text: @render3d_image.color_value.name },
          customisation_value: { id: @render3d_image.customisation_value_id, text: @render3d_image.customisation_value.try(:name) || '' }
        }
        @page_title = "Render3d::Image - #{@render3d_image.product_id} - #{@render3d_image.color_value_id} - #{@render3d_image.customisation_value_id}"
      end

      def new
        @render3d_image = Render3d::Image.new
      end

      def create
        render3d_params = params.fetch(:render3d_image, {})

        product_id = render3d_params.fetch(:product_id, nil)
        color_value_id = render3d_params.fetch(:color_value_id, nil)
        customisation_value_id = render3d_params.fetch(:customisation_value_id, 0)

        if Render3d::Image.exists?(product_id: product_id, customisation_value_id: customisation_value_id, color_value_id: color_value_id)
          redirect_to new_customisation_render3d_image_path, flash: { error: 'Render3d::Image already exist for such values' }
        end

        @render3d_image = \
          Render3d::Image.new.tap do |img|
            img.product_id = product_id
            img.color_value_id = color_value_id
            img.customisation_value_id = customisation_value_id
            img.attachment = render3d_params.fetch(:attachment, nil)
          end

        if @render3d_image.save
          message = { success: <<-EOS }
            Render3d Image was successfully created for:
              [*] product:\t\t<name (sku): #{@render3d_image.product.name_with_sku}>
              [*] color:\t\t<name: #{@render3d_image.color_value.name}>
              [*] customisation:\t<name: #{@render3d_image.customisation_value.try(:name) || 'Default'}>
            EOS
          redirect_to customisation_render3d_images_path, flash: message
        else
          redirect_to new_customisation_render3d_image_path, flash: { error: @render3d_image.errors.full_messages.to_sentence }
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
                [*] product:\t\t<name (sku): #{@render3d_image.product.name_with_sku}>
                [*] color:\t\t<name: #{@render3d_image.color_value.name}>
                [*] customisation:\t<name: #{@render3d_image.customisation_value.try(:name) || 'Default'}>
              EOS
          else
            { error: @render3d_image.errors.full_messages.to_sentence }
          end

        redirect_to customisation_render3d_images_path, flash: message
      end

      def destroy
        @render3d_image = Render3d::Image.find(params[:id])
        @render3d_image.destroy
        redirect_to customisation_render3d_images_path, flash: { success: 'Render3d Image was successfully removed' }
      end

      def collection
        limit = 30
        type = params.fetch(:type)
        term = params.fetch(:q).downcase

        collection = \
          case type
            when 'product'
              Spree::Product.joins(:master)
                .where('LOWER(spree_products.name) LIKE :term OR LOWER(spree_variants.sku) LIKE :term', term: "%#{term}%")
                .limit(limit)
                .map do |p|
                  { id: p.id, text: p.name_with_sku }
                end
            when 'color_value'
              Spree::OptionValue.joins(:product_color_values).colors
                .where('product_color_values.product_id = ?', params.fetch(:product_id))
                .where('LOWER(name) LIKE ?', "%#{term}%")
                .limit(limit)
                .map do |ov|
                  { id: ov.id, text: ov.name }
                end
            when 'customisation_value'
              CustomisationValue
                .where(product_id: params.fetch(:product_id))
                .where('LOWER(name) LIKE ?', "%#{term}%")
                .limit(limit)
                .map do |cv|
                  { id: cv.id, text: cv.name }
                end
            else
              []
          end

        respond_to do |format|
          format.json { render json: {
            collection: collection,
            type: type
          } }
        end
      end

    end
  end
end
