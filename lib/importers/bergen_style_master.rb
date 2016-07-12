require_relative './file_importer'

module Importers
  class BergenStyleMaster < FileImporter

    def import
      preface


      # Count lines fast
      progress = ProgressBar.create(total: csv_line_count, format: 'Processed: %c/%C  |%w%i|')
      CSV.foreach(csv_file, headers: true, skip_blanks: true, encoding: 'windows-1251:utf-8') do |csv_row|
        progress.increment

        bergen_product = BergenCsvTemplate.new(csv_row)

        # puts bergen_product.us_size
        # binding.pry
      end

      progress.finish


      #
      # Spree::Product.transaction do
      #   csv.each do |row|
      #     sku          = row['style'].downcase
      #     name         = row['name'].to_s
      #     factory_name = row['factory'].to_s.capitalize
      #
      #     product = Spree::Product.where('lower(name) = ?', name.downcase).first
      #     variant = Spree::Variant.where("spree_variants.sku ILIKE '#{sku}%'").first
      #
      #     unless variant || product
      #       warn "Skipping: No Product found for SKU='#{sku}' or name='#{name}'"
      #       next
      #     end
      #
      #     factory = Factory.find_or_create_by_name(factory_name)
      #
      #     product ||= variant.product
      #     old_factory_name = product.property(:factory_name)
      #
      #     product.factory = factory
      #     set_property    = product.set_property(:factory_name, factory_name)
      #     set_object      = product.save
      #
      #     if set_property && set_object
      #       progress.increment
      #       info "#{green("OK")} sku=#{sku} name=#{name} factory=#{old_factory_name} -> #{factory_name}"
      # end
      # end
      # progress.finish
      # end

      info 'Done'
    end

    private

    def csv_line_count
      # Thanks to http://stackoverflow.com/questions/2650517/count-the-number-of-lines-in-a-file-without-reading-entire-file-into-memory
      `wc -l "#{csv_file}"`.strip.split(' ')[0].to_i
    end

    class BergenCsvTemplate
      # {
      #   nil => "AU4",
      #   "STYLE" => "1310000DL",
      #   "COLOR" => "BLACK",
      #   "SIZE" => "US0",
      #   "BRIEFDESCRIPTION" => "Rock Goddess",
      #   "UPCCODE" => "14865",
      #   "MSRP" => "0"
      # }

      def initialize(csv_row)
        @color        = csv_row['COLOR']
        @product_name = csv_row['BRIEFDESCRIPTION']
        @size         = csv_row['SIZE']
        @style        = csv_row['STYLE']
        @upc          = csv_row['UPCCODE']
      end

      def color
        @color.downcase
      end

      def product_name
        @product_name.downcase
      end

      def us_size
        @size.downcase
      end

      def style
        @style.downcase
      end

      def upc
        @upc.downcase
      end
    end
  end
end
