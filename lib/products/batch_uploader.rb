require 'ostruct'
require 'roo'

module Products
  class BatchUploader
    attr_reader :parsed_data

    include ActionView::Helpers::TextHelper # for truncate

    def initialize
      @@titles_row_number = 5
      @@first_content_row_number = 7
    end

    def parse_file(filedata)
      @parsed_data = []
      return if filedata.nil?

      if filedata.original_filename =~ /\.xls$/
        book = Roo::Excel.new(filedata.tempfile.path, false, :warning)
      elsif filedata.original_filename =~ /\.xlsx$/
        # false - packed, warning - ignore not xslx format
        book = Roo::Excelx.new(filedata.tempfile.path, false, :warning)
      else
        raise 'Invalid file type'
      end


      book.default_sheet = book.sheets.first

      columns = get_columns_codes(book)
      rows = get_rows_indexes(book, columns)

      book.default_sheet = book.sheets.first

      rows.to_a.each do |row_num|
        raw = {}
        # Basic
        raw[:sku]              = book.cell(row_num, columns[:sku])
        raw[:name]             = book.cell(row_num, columns[:name])
        raw[:description]      = book.cell(row_num, columns[:description])
        raw[:price_in_aud]     = book.cell(row_num, columns[:price_in_aud])
        raw[:price_in_usd]     = book.cell(row_num, columns[:price_in_usd])
        raw[:taxons]           = Array.wrap(columns[:taxons]).map{|i| book.cell(row_num, i) }.reject(&:blank?)
        raw[:colors]           = Array.wrap(columns[:colors]).map{|i| book.cell(row_num, i) }.reject(&:blank?)
        # Style
        raw[:glam]             = book.cell(row_num, columns[:glam])
        raw[:girly]            = book.cell(row_num, columns[:girly])
        raw[:classic]          = book.cell(row_num, columns[:classic])
        raw[:edgy]             = book.cell(row_num, columns[:edgy])
        raw[:bohemian]         = book.cell(row_num, columns[:bohemian])
        raw[:sexiness]         = book.cell(row_num, columns[:sexiness])
        raw[:fashionability]   = book.cell(row_num, columns[:fashionability])
        raw[:apple]            = book.cell(row_num, columns[:apple])
        raw[:pear]             = book.cell(row_num, columns[:pear])
        raw[:strawberry]       = book.cell(row_num, columns[:strawberry])
        raw[:hour_glass]       = book.cell(row_num, columns[:hour_glass])
        raw[:column]           = book.cell(row_num, columns[:column])
        raw[:athletic]         = book.cell(row_num, columns[:athletic])
        raw[:petite]           = book.cell(row_num, columns[:petite])
        # Properties
        raw[:style_notes]      = book.cell(row_num, columns[:style_notes])
        raw[:fit]              = book.cell(row_num, columns[:fit])
        raw[:fabric]           = book.cell(row_num, columns[:fabric])
        raw[:product_type]     = book.cell(row_num, columns[:product_type])
        raw[:product_category] = book.cell(row_num, columns[:product_category])
        raw[:factory_id]       = book.cell(row_num, columns[:factory_id])
        raw[:factory_name]     = book.cell(row_num, columns[:factory_name])

        processed = {}

        if raw[:sku].present?
          if raw[:sku].is_a?(String) || raw[:sku].is_a?(Integer)
            processed[:sku] = raw[:sku].to_s
          elsif raw[:sku].is_a?(Float)
            processed[:sku] = raw[:sku].to_i.to_s
          end
        end

        if raw[:name].present?
          if raw[:name].is_a?(String)
            processed[:name] = raw[:name].titleize
          end
        end

        if raw[:description].present?
          processed[:description] = ActionController::Base.helpers.simple_format(raw[:description])
        end

        processed[:taxon_ids] = []
        raw[:taxons].each do |taxon_name|
          Spree::Taxon.all.each do |taxon|
            if taxon.name =~ Regexp.new(taxon_name, true)
              processed[:taxon_ids] << taxon.id
            end
          end
        end

        @parsed_data.push(
          OpenStruct.new(
            # Basic
            sku:              processed[:sku] || raw[:sku],
            name:             processed[:name] || raw[:name],
            price_in_aud:     raw[:price_in_aud],
            description:      processed[:description] || raw[:description],
            colors:           raw[:colors],
            taxon_ids:        processed[:taxon_ids],
            # Style Profile
            glam:             raw[:glam],
            girly:            raw[:girly],
            classic:          raw[:classic],
            edgy:             raw[:edgy],
            bohemian:         raw[:bohemian],
            sexiness:         raw[:sexiness],
            fashionability:   raw[:fashionability],
            apple:            raw[:apple],
            pear:             raw[:pear],
            strawberry:       raw[:strawberry],
            hour_glass:       raw[:hour_glass],
            column:           raw[:column],
            athletic:         raw[:athletic],
            petite:           raw[:petite],
            # Properties
            style_notes:      raw[:style_notes],
            fit:              raw[:fit],
            fabric:           raw[:fabric],
            product_type:     raw[:product_type],
            product_category: raw[:product_category],
            factory_id:       raw[:factory_id],
            factory_name:     raw[:factory_name]
          )
        )
      end

      @parsed_data
    end

    def get_columns_codes(book)
      return @codes if @codes.present?

      book.default_sheet = book.sheets.first
      @codes = {}

      conformities = {
        # Basic
        sku: /style #/i,
        name: /product name/i,
        description: /description/i,
        price_in_aud: /rrp/i,
        price_in_usd: /price usd/i,
        taxons: /taxons? \d+/i,
        colors: /(color|colour) \d+$/i,
        # Style Profile
        glam: /glam/i,
        girly: /girly/i,
        classic: /classic/i,
        edgy: /edgy/i,
        bohemian: /boho/i,
        sexiness: /sexy/i,
        fashionability: /fashion/i,
        apple: /apple/i,
        pear: /pear/i,
        strawberry: /strawberry/i,
        hour_glass: /hourglass|hourgalss/i,
        column: /column/i,
        athletic: /athletic/i,
        petite: /petite/i,
        # Properties
        style_notes: /styling notes/i,
        fit: /size.+fit/i,
        fabric: /fabric/i,
        product_type: /product type/i,
        product_category: /product category/i,
        factory_id: /factory id/i,
        factory_name: /factory name/i
      }

      conformities.each do |key, regex|
        indexes = []

        book.row(@@titles_row_number).each_with_index do |title, index|
          if title =~ regex
            indexes << (index + 1)
          end
        end

        if indexes.present?
          if indexes.count.eql?(1)
            @codes[key] = indexes.first
          else
            @codes[key] = indexes
          end
        else
          @codes[key] = nil
        end
      end

      @codes
    end

    def get_rows_indexes(book, columns)
      first_empty_row_num = @@first_content_row_number

      total_rows = book.last_row(book.sheets.first)
      while first_empty_row_num < total_rows and book.cell(first_empty_row_num, columns[:name]).present?
        first_empty_row_num += 1
      end

      (@@first_content_row_number...first_empty_row_num)
    end

    # create product with restored data
    def create_products(products_attrs)
      products_attrs.map do |attrs|
        args = attrs.symbolize_keys
        product = create_product(args.merge!(
          sizes: %W{8 10 12 14 16}
        ))

        add_product_properties(product, args[:properties].symbolize_keys)
        add_product_variants(product, args[:sizes], args[:colors])
        add_product_style_profile(product, args[:style_profile].symbolize_keys)

        product
      end
    end

    private

    def create_product(args)
      product_attributes = {
        name: args[:name],
        price: args[:price_in_aud],
#        us_price: args[:us_price],
        description: args[:description],
        featured: false,
        on_demand: true,
        sku: args[:sku],
        permalink: args[:name].downcase.gsub(/\s/, '_'),
        taxon_ids: args[:taxon_ids]
      }

      product = Spree::Product.create!(product_attributes)

      add_product_prices(product, args[:price_in_aud], args[:price_in_usd])

      product
    end

    def add_product_properties(product, args)
      {
        style_notes: args[:style_notes],
        fit: args[:fit],
        fabric: args[:fabric],
        product_type: args[:product_type],
        product_category: args[:product_category],
        factory_id: args[:factory_id],
        factory_name: args[:factory_name]
      }.each do |property_name, property_value|

        product.set_property(property_name, property_value)
      end

      product
    end

    def add_product_variants(product, sizes, colors)
      variants = []
      size_option = Spree::OptionType.where(name: 'dress-size').first
      color_option = Spree::OptionType.where(name: 'dress-color').first

      product.option_types = [size_option, color_option]
      product.save

      sizes.each do |size_name|
        colors.each do |color_name|
          size_value  = size_option.option_values.where(name: size_name).first
          color_value = color_option.option_values.where(name: color_name).first

          next if size_value.blank? || color_value.blank?

          variant = product.variants.build
          variant.on_demand = true
          variant.option_values = [size_value, color_value]
          variant.price = product.price
          variant.save

          variants.push(variant)
        end
      end

      variants
    end

    def add_product_style_profile(product, args)
      attributes = args.slice(:glam,
                              :girly,
                              :classic,
                              :edgy,
                              :bohemian,
                              :sexiness,
                              :fashionability,
                              :apple,
                              :pear,
                              :strawberry,
                              :hour_glass,
                              :column,
                              :athletic,
                              :petite)

      attributes.each do |key, value|
        attributes[key] = value.to_s.to_i
      end

      basic_style_names = [:glam, :girly, :classic, :edgy, :bohemian]
      total = 0
      factor = attributes.slice(*basic_style_names).values.sum / 10.0

      unless factor.eql?(0.0)
        basic_style_names.each do |style_name|
          points = (attributes[style_name] / factor).round

          if total >= 10
            points = 0
          elsif (points + total) > 10
            points = 10 - total
          elsif basic_style_names.last.eql?(style_name) && (total + points) < 10
            points = 10 - total
          end

          attributes[style_name] = points
          total += points
        end
      end

      product.style_profile.update_attributes(attributes)
    end

    def add_product_prices(product, price, us_price = nil)
      product.price = price
      #us_price ||= price
      #product.us_price = us_price

      product.save
    end
  end
end
