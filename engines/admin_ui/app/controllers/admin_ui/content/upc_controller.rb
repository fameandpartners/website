module AdminUi
  module Content
    class UpcController < ::AdminUi::ApplicationController

      # for convenience when on the create response screen and refresh screen
      def index
        redirect_to new_content_upc_url
      end

      def new
        @form = Forms::SkuUpcForm.new( OpenStruct.new )
      end

      def create
        @form = Forms::SkuUpcForm.new( OpenStruct.new )
        @sizes_empty = true if params[:sku_upc][:sizes].blank?
        if @form.validate( params[:sku_upc] ) && params[:sku_upc][:sizes].present?
          @results = {}
          product = @form.selected_product
          # customization fields are free form text that allow multiple values
          # seperated with a comma. Lookup or create CustomisationValue to pass to GlobalSku
          # customization_ids = @form.customization_id&.split(',') || []
          # customization_names = @form.customization_name&.split(',') || []
          # customizations = find_or_create_customizations(customization_ids, customization_names)

          # Save form to access
          @form.save do |hash|
            ensure_color_exists(
              hash[:color_name].parameterize,
              hash[:color_presentation_name].titleize
            )
            # gather upc numbers for each size combo
            hash[:sizes].each do |size|
              sku = find_or_create_sku(
                product.sku.squish.downcase,
                product.name.squish.upcase,
                hash[:height].upcase,
                hash[:color_name].parameterize,
                size,
                customizations
              )
              update_sku_customizations(sku, hash[:customization_id], hash[:customization_name])
              # collect all the upc codes per size
              @results[size] = sku.upc
            end
          end
        end
        # always render new with results or errors
        render :new
      end

      private

      def find_or_create_customizations(ids, names)
        # normalize form data to keep nil if empty string
        # sku.customisation_id = id.blank? ? nil : id
        # sku.customisation_name = name.blank? ? nil : name
        # sku.save
      end

      def ensure_color_exists( color_name, presentation_name )
        option_type = Spree::OptionType.color
        option_type.option_values.where( {name: color_name} ).first_or_create( {presentation: presentation_name} )
      end

      def find_or_create_sku( style_number, style_name, height, color_name, size, customizations )
        sku_value = Skus::Generator.new(
          style_number: style_number,
          size: size,
          color_id: Spree::OptionValue.where(name: color_name).first.id,
          height: height,
          customization_value_ids: customizations.collect(&:id)
        ).call
        sku = GlobalSku.find_by_sku( sku_value )
        # Create sku if not found
        if sku.nil?
          sku = GlobalSku::Create.new(
            style_number: style_number,
            product_name: style_name,
            size: size,
            color_name: color_name,
            height: height,
            customizations: customizations
          ).call
        end

        return sku
      end

    end
  end
end
