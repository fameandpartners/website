require 'importers/sku_generation'

module Admin
  class SkuGenerationsController < Spree::Admin::BaseController

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

    def show
      templates = []

      dummy_size = ::Importers::SkuGeneration::BaseSize.new(99)

      Spree::Product
        .where(deleted_at: nil)
        .includes(:variants => [], :master => [], :fabric_card => { :colours => :fabric_colour } )
        .find_each do |product|


        product_template = ::Importers::SkuGeneration::ProductTemplate.new(
          product.sku,
          product.name
        )
        product_template.fabric_card = product.fabric_card
        product_template.base_sizes = [dummy_size]

        templates << product_template
      end

      @product_templates = templates
    end
  end
end
