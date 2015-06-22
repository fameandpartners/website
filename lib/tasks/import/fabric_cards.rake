namespace :import do
  desc 'fabric_colour_cards'
  task :fabric_colour_cards => :environment do

    ENV['FILE_PATH'] ||= File.join(Rails.root, 'contentspreadsheets', 'fabric_cards_colours.csv')

    raise 'FILE_PATH required' if ENV['FILE_PATH'].blank?
    Importers::SkuGeneration::FabricCardImporter.new(ENV['FILE_PATH']).import
  end

  desc 'fabric_cards'
  task :fabric_cards => :environment do

    ENV['FILE_PATH'] ||= File.join(Rails.root, 'contentspreadsheets', 'fabric_cards.csv')

    raise 'FILE_PATH required' if ENV['FILE_PATH'].blank?

    csv = CSV.read(ENV['FILE_PATH'],
                   headers:           true,
                   skip_blanks:       true,
                   header_converters: ->(h) { h.to_s.strip }
    )

    csv.each do |row|

      name    = row["name"]
      code    = row["code"]
      # name_zh = row["name_zh"]
      fc = FabricCard.find_or_create_by_name_and_code(name, code)
      puts fc.inspect
    end
  end



  desc 'products with fabric_cards'
  task :fabric_cards_products => :environment do

    ENV['FILE_PATH'] ||= File.join(Rails.root, 'contentspreadsheets', 'products_fabric_cards.csv')

    raise 'FILE_PATH required' if ENV['FILE_PATH'].blank?

    csv = CSV.read(ENV['FILE_PATH'],
                   headers:           true,
                   skip_blanks:       true,
                   header_converters: ->(h) { h.to_s.strip }
    )

    row_format = "%8s | %-30s | %-30s | %s"

    csv.each do |row|

      style_number = row["STYLE NUMBER"]
      style_name   = row["STYLE NAME"]
      fabric_name  = row["FABRIC"]

      fabric  = FabricCard.where(FabricCard.arel_table[:name].matches(fabric_name)).first
      product = Spree::Product.where(Spree::Product.arel_table[:name].matches(style_name)).first

      puts "%8s | %-30s | %-30s | %-20s | %-20s " % [style_number,
                                         style_name,
                                         fabric_name,
                                         product.try(:name) || "-",
                                         fabric.try(:name) || "-",
                                         ]
      if product && fabric
        product.fabric_card = fabric
        state = product.save!
      else

        # binding.pry
      end
    end
  end
end
