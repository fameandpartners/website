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
          @form.save do |hash|
            ensure_color_exists(
              hash[:color_name].parameterize,
              hash[:color_presentation_name].titleize
            )
            # gather upc numbers for each size combo
            hash[:sizes].each do |size|
              upc = find_or_create_sku(
                hash[:style_number].downcase,
                hash[:style_name].upcase,
                hash[:height].upcase,
                hash[:color_name].parameterize,
                size
              ).upc
              @results[size] = upc
            end
          end
        end
        # always render new with results or errors
        render :new
      end

      private

      def ensure_color_exists( color_name, presentation_name )
        option_type = Spree::OptionType.color
        option_type.option_values.where( {name: color_name} ).first_or_create( {presentation: presentation_name} )
      end

      def find_or_create_sku( style_number, style_name, height, color_name, size )
        sku_value = Skus::Generator.new(
          style_number: style_number,
          size: size,
          color_id: Spree::OptionValue.where(name: color_name).first.id,
          height: height,
          customization_value_ids: []
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
            customizations: []
          ).call
        end

        return sku
      end

    end
  end
end
