module Importers
  class InventoryIngestor

    def get_file(url)

    end



    def self.ingest_bergen(file)
      ReturnInventoryItem.deactivate_all_records!('bergen')
      # file = Rails.root.join('lib/importers/Inventory_1518119212121.csv').to_s

      file_stream = file  #File.open(file, 'r')
      csv = CSV.parse(file_stream, headers: true, header_converters: :symbol, skip_blanks: true )
      count = 0

      csv.each do |row|
        if row[:upccode].strip.length < 8 && row[:upccode].strip.scan(/\D/).empty?
          ReturnInventoryItem.create!(upc: row[:upccode].strip, style_number: row[:style].strip, available: row[:available], vendor: 'bergen')
          count += 1
        end
      end

      count
    end

    def self.ingest_next(file)
      ReturnInventoryItem.deactivate_all_records!('next')
      # file = Rails.root.join('lib/importers/next inventory.csv').to_s

      file_stream = file  #File.open(file, 'r')
      csv = CSV.parse(file_stream, headers: true, header_converters: :symbol, skip_blanks: true)
      count = 0

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
          count += 1
        end

        count
      end
    end
  end
end
