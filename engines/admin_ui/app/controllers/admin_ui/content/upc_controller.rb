module AdminUi
  module Content
    class UpcController < ::AdminUi::ApplicationController

      def new
        @form = Forms::SkuUpcForm.new( OpenStruct.new )
      end

      def create
        @form = Forms::SkuUpcForm.new( OpenStruct.new )
        if @form.validate( params[:sku_upc] )
          upcs = []
          @form.save do |hash|
            ensure_color_exists(
              hash[:color_name].parameterize,
              hash[:color_presentation_name].titleize
            )
            # gather upc numbers for each size combo
            hash[:sizes].split(" ").each do |size|
              upcs << generate_sku(
                hash[:style_number].downcase,
                hash[:style_name].upcase,
                hash[:height].upcase,
                hash[:color_name].parameterize,
                size
              ).upc
            end
            puts "WE CREATED SOME UPC'S ****************"
            pp upcs
          end
        else
          puts "ERRORS *************"
        end
        render :new
      end

      private

      def ensure_color_exists( color_name, presentation_name )
        option_type = Spree::OptionType.color
        option_type.option_values.where( {name: color_name} ).first_or_create( {presentation: presentation_name} )
      end

      def generate_sku( style_number, style_name, height, color_name, size )
        sku = GlobalSku::Create.new(
          style_number: style_number,
          product_name: style_name,
          size: size,
          color_name: color_name,
          height: height,
          customizations: []
        ).call
        # Look up sku if the creation failed
        if sku.blank?
          sku_value = Skus::Generator.new(
            style_number: style_number,
            size: size,
            color_id: Spree::OptionValue.where(name: color_name).first.id,
            height: height,
            customization_value_ids: []
          ).call
          sku = GlobalSku.find_by_sku( sku_value )
        end

        return sku
      end

    end
  end
end
