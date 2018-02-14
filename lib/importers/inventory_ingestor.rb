module Importers
  class InventoryIngestor

    def get_file(url)

    end

    def

    def self.ingest_bergen(file)
      file = Rails.root.join('lib/importers/Inventory_1518119212121.csv').to_s

      file_stream = File.open(file, 'r')
      csv = CSV.parse(file_stream, headers: true, header_converters: :symbol, skip_blanks: true )

      csv.each do |row|
        if row[:upccode].strip.length < 8 && row[:upccode].strip.scan(/\D/).empty?
          ReturnInventoryItem.create!(upc: row[:upccode], style_number: row[:style], available: row[:available], vendor: 'bergen')
        end
      end
    end

    def self.ingest_next(file)
      file = Rails.root.join('lib/importers/next inventory.csv').to_s

      file_stream = File.open(file, 'r')
      csv = CSV.parse(file_stream, headers: true, header_converters: :symbol, skip_blanks: true)

      csv.each do |row|
        if row[:sku].strip.scan(/\D/).empty?
          upc = row[:sku].strip
        else
          splits = row[:sku].strip.split('/')
          if splits[0].strip.scan(/\D/).empty?
            upc = splits[0].strip
          end
        end

        if upc
          ReturnInventoryItem.create!(upc: upc, available: row[:available], vendor: 'next')
        end

      end
    end
  end
end
