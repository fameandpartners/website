require 'importers/sku_generation'

module Admin
  class SkuGenerationsController < Spree::Admin::BaseController
    include Concerns::GlobalController

    def create
      import_file = params[:sku_template_csv].tempfile

      importer = Importers::SkuGeneration::Importer.new(import_file,  StringIO.new)
      importer.parse_file

      send_data(
        importer.generate_comparison_csv,
        :type => 'text/csv',
        :filename => "skus_generated_#{DateTime.now.to_s(:file_timestamp)}.csv"
      )
    end

    def show; end
  end
end
