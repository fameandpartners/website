require_relative './file_importer'

module Importers
  class BergenStyleMaster < FileImporter

    def import
      preface

      parse_file do |csv_row|
        bergen_product = BergenProductTemplate.new(csv_row, logger: @logger)

        unless bergen_product.exists?
          global_sku_upc = bergen_product.create_global_sku
          info ['Creating Global SKU for', bergen_product.to_s.ljust(35), global_sku_upc].join(' ')
        end
      end

      info 'Done'
    end

    private

    def parse_file
      csv_line_count = `wc -l "#{csv_file}"`.strip.split(' ')[0].to_i # Thanks to http://stackoverflow.com/questions/2650517/count-the-number-of-lines-in-a-file-without-reading-entire-file-into-memory
      progress       = ProgressBar.create(total: csv_line_count, format: 'Processed: %c/%C')
      CSV.foreach(csv_file, headers: true, skip_blanks: true, encoding: 'windows-1251:utf-8') do |csv_row|
        progress.increment
        yield csv_row
      end
      progress.finish
    end

    class BergenProductTemplate
      CSV_HEADERS = {
        color: 'Color',
        size:  'Full Size',
        style: 'Style'
      }

      include Term::ANSIColor
      extend Forwardable
      def_delegators :@logger, :warn

      def initialize(csv_row, logger: STDOUT)
        @color = csv_row[CSV_HEADERS[:color]]
        @size  = csv_row[CSV_HEADERS[:size]]
        @style = csv_row[CSV_HEADERS[:style]]

        @logger = logger
      end

      def color
        @color.downcase
      end

      def us_size
        @size.downcase
      end

      def style
        @style.downcase.strip
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
        master = Spree::Variant.where(is_master: true).where('LOWER(TRIM(sku)) = ?', style).first

        if master.nil?
          did_not_create_error 'SKU does not exist'
          return
        end

        product      = master.product
        size_option  = Spree::OptionType.size
        color_option = Spree::OptionType.color

        spree_size_option_value  = size_option.option_values.where('name ILIKE ?', "%#{us_size}%").first
        spree_color_option_value = color_option.option_values.where('name ILIKE ?', color).first

        if spree_size_option_value.blank?
          did_not_create_error 'Size option does not exist'
          return
        end

        if spree_color_option_value.blank?
          did_not_create_error 'Color option does not exist'
          return
        end

        spree_variant = find_or_create_product_variant(product, spree_size_option_value, spree_color_option_value)
        add_product_color_option(product, spree_color_option_value)

        # Create Global SKU
        global_sku = GlobalSku.find_or_create_by_spree_variant(variant: spree_variant)
        global_sku.upc
      end

      private

      def find_or_create_product_variant(spree_product, spree_size_option_value, spree_color_option_value)
        # Variant must not show on store front. It MUST be marked as deleted_at

        # - Deleted at?
        # - Price
        # - Color
        # - Size

        product_variants = Spree::Variant.where(product_id: spree_product.id)
        spree_variant    = product_variants.detect do |variant|
          [spree_size_option_value.id, spree_color_option_value.id].all? { |id|
            variant.option_value_ids.include?(id)
          }
        end

        if spree_variant.nil?
          spree_variant = spree_product.variants.build

          # Avoids errors with Spree hooks updating lots and lots of orders.
          # See: spree/core/app/models/spree/variant.rb:146 #on_demand=
          spree_variant.send :write_attribute, :on_demand, true

          spree_variant.option_values = [spree_size_option_value, spree_color_option_value]
          spree_variant.deleted_at    = 1.day.ago

          spree_variant.save
        end

        spree_variant
      end

      def add_product_color_option(spree_product, spree_color_option_value)
        # If ProductColorValue on dress + color combination (custom or not):
        # Create a ProductColorValue as NOT CUSTOM and INACTIVE

        unless spree_product.product_color_values.exists?(option_value_id: spree_color_option_value.id)
          ProductColorValue.create(
            product_id:      spree_product.id,
            option_value_id: spree_color_option_value.id,
            active:          false,
            custom:          false
          )
        end
      end

      def did_not_create_error(message)
        warn [message, style, color, us_size].join(', ')
      end
    end
  end
end
