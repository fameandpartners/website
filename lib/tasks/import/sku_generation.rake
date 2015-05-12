namespace :import do
  desc 'sku_generation_template'
  task :sku_generation_template => :environment do
    raise 'FILE_PATH required' if ENV['FILE_PATH'].blank?

    Importers::SkuGeneration::Importer.new(ENV['FILE_PATH']).import
  end

  desc :fabric_colour_cards
  task :fabric_colour_cards => :environment do
    raise 'FILE_PATH required' if ENV['FILE_PATH'].blank?
    Importers::SkuGeneration::FabricCardImporter.new(ENV['FILE_PATH']).import
  end

  desc 'spike fabric colours'
  task :spike_fabric_colours => :environment do

    yiwan8012 = FabricCardTemplate.new 'yiwan8012', 'YI12'
    colours   = {
      'Blush'         => 83,
      'Burgundy'      => 91,
      'Burnt Orange'  => 97,
      'Champagne'     => 8,
      'Charcoal'      => 49,
      'Cherry Red'    => 4,
      'Cobalt Blue'   => 24,
      'Coral'         => 81,
      'Cream'         => 29,
      'Emerald Green' => 77,
      'Fluoro Orange' => 116,
      'Ivory'         => 72,
      'Lavender'      => 106,
      'Lemon'         => 32,
      'Light Blue'    => 21,
      'Light Pink'    => 25,
      'Lilac'         => 52,
      'Magenta'       => '9/108',
      'Marine Blue'   => 101,
      'Mint'          => 115,
      'Moss Green'    => 33,
      'Navy'          => 46,
      'Off White'     => 12,
      'Orange'        => 59,
      'Pale Blue'     => 21,
      'Pale Green'    => 78,
      'Pale Grey'     => 43,
      'Pale Pink'     => 25,
      'Pale Yellow'   => 124,
      'Peach'         => 44,
      'Pine'          => 104,
      'Plum'          => 57,
      'Purple'        => 71,
      'Red'           => 36,
      'Taupe'         => 92,
      'Teal'          => 48,
      'Turqoise'      => 120,
      'Watermelon'    => 47
    }


    yiwan8012.colours  = colours.collect do |name, number|
      FabricCardColourTemplate.new(number, name)
    end
    imogen             = ProductTemplate.new '13053', 'Imogen'
    imogen.fabric_card = yiwan8012

    imogen
    binding.pry
  end


  desc :existing_spree_variants
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
