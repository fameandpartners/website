module Api
  module V1
    class FabricSwatchesController < ApplicationController
      include SslRequirement
      helper 'spree/users', 'spree/base'
      include Spree::Core::ControllerHelpers::Auth

      ssl_required :new, :create, :destroy
      respond_to :json
      skip_before_filter :verify_authenticity_token

      def index
        binding.pry
        prd = Spree::Product.find_by_name('Fabric Swatch - Heavy Georgette')
        output = prd.variants.map do |swatch_variant|
          {
            variant_id: swatch_variant.id,
            product_id: swatch_variant.product.id,
            sku: swatch_variant.sku,
            color_name: swatch_variant.dress_color.presentation,
            color_id: swatch_variant.dress_color.id,
          }
        end

        respond_with output.to_json
      end


    end


  end
end
