namespace :import do
  desc 'sku_generation_template'
  task :sku_generation_template => :environment do
    raise 'FILE_PATH required' if ENV['FILE_PATH'].blank?

    Importers::SkuGeneration::Importer.new(ENV['FILE_PATH']).import
  end

  desc 'fabric_colour_cards'
  task :fabric_colour_cards => :environment do

    ENV['FILE_PATH'] ||= File.join(Rails.root, 'contentspreadsheets', 'fabric_cards_colours.csv')

    raise 'FILE_PATH required' if ENV['FILE_PATH'].blank?
    Importers::SkuGeneration::FabricCardImporter.new(ENV['FILE_PATH']).import
  end

  desc 'existing_spree_variants as skus in CSV format'
  task :existing_spree_variants => :environment do

    csv_string = CSV.generate(headers: true) do |csv|
      csv << ['Style Number', 'Style Name', 'Colour Name', 'Size', 'SpreeSKU']
      Spree::Product.where(deleted_at: nil).each do |product|
        product.variants.active.where(is_master: false).each do |variant|
          # Even this doesn't work, crazy lexicographical sorting
          # .sort_by { |v| [v.dress_color.try(:presentation).presence || 'no_colour' , v.dress_size.try(:presentation).presence || 0] }
          style_number = variant.sku.split('-').first

          csv << [
            style_number,
            product.name,
            variant.dress_color.try(:presentation) || :no_colour,
            variant.dress_size.try(:presentation) || :no_size,
            variant.sku
          ]
        end
      end
    end
    puts csv_string
  end
end
