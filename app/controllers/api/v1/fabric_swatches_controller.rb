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
        # ReturnInventoryItem.truncate!
        # Importers::InventoryIngestor.ingest_bergen('bla')
        # Importers::InventoryIngestor.ingest_next('bla')
        # balls = Refulfiller.get_line_items_between('2018-01-31', Time.now)
        # Refulfiller.check_line_items_in_inventory(balls)
        # balls = Batcher.get_line_items_between('2018-02-01', Time.now)
        # binding.pry
        # Batcher.batch_line_items(Batcher.get_line_items_between('2018-01-31', Time.now))
        colors = fabric_swatch_colors
        respond_with colors.to_json
      end


    end


  end
end
