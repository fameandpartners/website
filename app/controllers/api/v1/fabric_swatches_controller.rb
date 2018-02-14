module Api
  module V1
    class FabricSwatchesController < ApplicationController
      include SslRequirement

      helper 'spree/users', 'spree/base'
      include ProductsHelper
      include Spree::Core::ControllerHelpers::Auth

      ssl_required :new, :create, :destroy
      respond_to :json
      skip_before_filter :verify_authenticity_token

      def index
        # Importers::InventoryIngestor.ingest_bergen('bla')
        Importers::InventoryIngestor.ingest_next('bla')
        colors = fabric_swatch_colors
        respond_with colors.to_json
      end


    end


  end
end
