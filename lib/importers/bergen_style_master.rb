require_relative './file_importer'

module Importers
  class BergenStyleMaster < FileImporter

    def import
      preface


      parse_file do |csv_row|
        bergen_product = BergenProductTemplate.new(csv_row)

        # generate_global_sku(bergen_product, spree_product)
        # generate_comparison_csv()

        # puts bergen_product.us_size
        # binding.pry
      end


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

    def compare
      preface

      matched_csv   = BergenCsvTemplate.new('bergen_matched.csv')
      unmatched_csv = BergenCsvTemplate.new('bergen_unmatched.csv')

      parse_file do |csv_row|
        bergen_product = BergenProductTemplate.new(csv_row)

        # Match Bergen Product
        # => Global SKU?
        # => Style + Size + ?

        global_sku     = GlobalSku.where(id: bergen_product.upc).first

        matched_csv << csv_row
        unmatched_csv << csv_row

        binding.pry if global_sku.nil?

        break if bergen_product.upc == '11379'

      end

      matched_csv.close
      unmatched_csv.close

      info 'Done'
      info 'Comparison CSV file '
    end

    private

    def parse_file
      progress = ProgressBar.create(total: csv_line_count, format: 'Processed: %c/%C  |%w%i| %e')
      CSV.foreach(csv_file, headers: true, skip_blanks: true, encoding: 'windows-1251:utf-8') do |csv_row|
        progress.increment
        yield csv_row
      end
      progress.finish
    end

    def csv_line_count
      # Thanks to http://stackoverflow.com/questions/2650517/count-the-number-of-lines-in-a-file-without-reading-entire-file-into-memory
      `wc -l "#{csv_file}"`.strip.split(' ')[0].to_i
    end

    class BergenProductTemplate
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

    class BergenCsvTemplate
      HEADERS = %w(CONCAT STYLE COLOR US_SIZE AU_SIZE BRIEFDESCRIPTION UPCCODE MSRP)

      extend Forwardable

      attr_reader :file
      def_delegators :file, :<<, :close

      def initialize(csv_name)
        @file = CSV.open(Rails.root.join('tmp', csv_name), 'wb')
        write_headers

        @file
      end

      def write_headers
        file << HEADERS
      end
    end
  end
end
