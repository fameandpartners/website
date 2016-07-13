require_relative './file_importer'

module Importers
  class BergenStyleMaster < FileImporter

    def import
      preface

      parse_file do |csv_row|
        bergen_product = BergenProductTemplate.new(csv_row)

        unless bergen_product.exists?
          global_sku = bergen_product.create_global_sku
          warn ['Creating Global SKU for', bergen_product.to_s.ljust(35), global_sku].join(' ')
        end
      end


      info 'Done'
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
      CSV_HEADERS = {
        color: 'Color',
        size:  'Full Size',
        style: 'Style'
      }

      def initialize(csv_row)
        @color = csv_row[CSV_HEADERS[:color]]
        @size  = csv_row[CSV_HEADERS[:size]]
        @style = csv_row[CSV_HEADERS[:style]]
      end

      def color
        @color.downcase
      end

      def us_size
        @size.downcase
      end

      def style
        @style.downcase
      end

      def to_s
        [
          style,
          color,
          us_size
        ].join(', ')
      end

      def exists?
        GlobalSku.
          where('style_number ILIKE ?', style).
          where('size ILIKE ?', "%#{us_size}%").
          where('color_name ILIKE ?', color).
          any?
      end

      def create_global_sku
        # variant = Spree::Variant.where('sku ILIKE ?', style).first
        Spree::Variant.
          includes(:option_values).
          where('sku ILIKE ?', "#{style}%").
          where('spree_option_values.name ILIKE ?', color).
          where('spree_option_values.name ILIKE ?', "%#{us_size}%").
          to_sql

        # TODO: How to handle variants that never existed in the system!?


        'Super Global SKU!'
      end
    end
  end
end
