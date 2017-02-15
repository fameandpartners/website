require 'roo'
require 'log_formatter'

# Note: this uploader was made only for the reshoot that happend on July 2016
# This will use a very specific spreadsheet called `MasterContent-ReShoot-FINAL.xlsx`
module Products
  class BatchUploaderReshoot
    extend Forwardable
    def_delegators :@logger, :info, :debug, :warn, :error, :fatal

    attr_reader :parsed_data

    include ActionView::Helpers::TextHelper # for truncate

    def initialize(logdev: $stdout)
      @logger           = Logger.new(logdev)
      @logger.level     = Logger::INFO
      @logger.formatter = LogFormatter.terminal_formatter
    end

    # The Master Product spreadsheet has a 'unique' structure, and rather than detecting it,
    # this script just hard codes the rows.
    #  1 |
    #  2 |
    #  3 |
    #  4 |
    #  5 | MASTER PRODUCT SPREADSHEET # Document Heading
    #  6 |
    #  7 |
    #  8 | [Merged Row] # Column Group Headings
    #  9 | [Merged Row]
    # 10 |              # Main Column Heading
    # 11 |              # Column Sub Heading (Seems unused by script)
    # 12 |              # Column Sub Sub Heading (Seems unused by script)
    # 13 |              # First row of content `first_content_row_number`
    private def titles_row_numbers
      [8, 10, 11, 12]
    end

    private def main_column_heading_row
      titles_row_numbers.second
    end

    private def first_content_row_number
      13
    end

    def parse_file(file_path)
      info "Loading Excel File #{file_path}"
      return if file_path.nil?

      if file_path =~ /\.xls$/
        book = Roo::Excel.new(file_path, false, :warning)
      elsif file_path =~ /\.xlsx$/
        # false - packed, warning - ignore not xslx format
        book = Roo::Excelx.new(file_path, false, :warning)
      else
        raise 'Invalid file type'
      end

      book.default_sheet = book.sheets.first
      columns            = get_column_indices(book)
      rows               = get_rows_indexes(book, columns)

      info 'Parsing Data into Hash'

      @parsed_data = rows.to_a.map do |row_num|
        raw       = extract_raw_row_data(book, columns, row_num)
        processed = process_raw_row_data(raw)

        build_item_hash(processed, raw)
      end

      info 'Parse Complete'
    end

    private def extract_raw_row_data(book, columns, row_num)
      raw                              = {}

      # Basic
      raw[:sku]                        = book.cell(row_num, columns[:sku])
      raw[:name]                       = book.cell(row_num, columns[:name])
      raw[:description]                = book.cell(row_num, columns[:description])
      raw[:price_in_aud]               = book.cell(row_num, columns[:price_in_aud])
      raw[:price_in_usd]               = book.cell(row_num, columns[:price_in_usd])
      raw[:taxons]                     = Array.wrap(columns[:taxons]).map { |i| book.cell(row_num, i) }.reject(&:blank?)
      raw[:colors]                     = Array.wrap(columns[:colors]).map { |i| book.cell(row_num, i) }.reject(&:blank?)

      # Style
      raw[:glam]                       = book.cell(row_num, columns[:glam])
      raw[:girly]                      = book.cell(row_num, columns[:girly])
      raw[:classic]                    = book.cell(row_num, columns[:classic])
      raw[:edgy]                       = book.cell(row_num, columns[:edgy])
      raw[:bohemian]                   = book.cell(row_num, columns[:bohemian])
      raw[:sexiness]                   = book.cell(row_num, columns[:sexiness])
      raw[:fashionability]             = book.cell(row_num, columns[:fashionability])
      raw[:apple]                      = book.cell(row_num, columns[:apple])
      raw[:pear]                       = book.cell(row_num, columns[:pear])
      raw[:strawberry]                 = book.cell(row_num, columns[:strawberry])
      raw[:hour_glass]                 = book.cell(row_num, columns[:hour_glass])
      raw[:column]                     = book.cell(row_num, columns[:column])
      raw[:athletic]                   = book.cell(row_num, columns[:athletic])
      raw[:petite]                     = book.cell(row_num, columns[:petite])
      # Properties
      raw[:style_notes]                = book.cell(row_num, columns[:style_notes])
      raw[:care_instructions]          = book.cell(row_num, columns[:care_instructions])
      raw[:fit]                        = book.cell(row_num, columns[:fit])
      raw[:size]                       = book.cell(row_num, columns[:size])
      raw[:fabric]                     = book.cell(row_num, columns[:fabric])
      raw[:product_type]               = book.cell(row_num, columns[:product_type])
      raw[:product_category]           = book.cell(row_num, columns[:product_category])
      raw[:factory_id]                 = book.cell(row_num, columns[:factory_id])
      raw[:factory_name]               = book.cell(row_num, columns[:factory_name])
      raw[:product_coding]             = book.cell(row_num, columns[:product_coding])
      raw[:shipping]                   = book.cell(row_num, columns[:shipping])
      raw[:stylist_quote_short]        = book.cell(row_num, columns[:stylist_quote_short])
      raw[:stylist_quote_long]         = book.cell(row_num, columns[:stylist_quote_long])
      raw[:product_details]            = book.cell(row_num, columns[:product_details])
      raw[:revenue]                    = book.cell(row_num, columns[:revenue])
      raw[:cogs]                       = book.cell(row_num, columns[:cogs])
      raw[:color_customization]        = book.cell(row_num, columns[:color_customization])
      raw[:available_colors]           = book.cell(row_num, columns[:available_colors])
      raw[:standard_days_for_making]   = book.cell(row_num, columns[:standard_days_for_making])
      raw[:customised_days_for_making] = book.cell(row_num, columns[:customised_days_for_making])
      raw[:short_description]          = book.cell(row_num, columns[:short_description])

      # Additional
      raw[:song_link]                  = book.cell(row_num, columns[:song_link])
      raw[:song_name]                  = book.cell(row_num, columns[:song_name])

      raw[:customizations] = []
      columns[:customizations].each_with_index do |customization, index|
        raw[:customizations] << {
          name:     book.cell(row_num, customization[:name]).to_s.gsub("_x000D_", '').strip,
          price:    book.cell(row_num, customization[:price]).to_s.gsub(/[^\d\.]/, '').to_f,
          position: index + 1
        }
      end
      info "Row #{row_num} - Extracted Raw Data for SKU: #{raw[:sku]}"
      raw
    end

    private def process_raw_row_data(raw)
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

      if raw[:product_details].present?
        processed[:product_details] = ActionController::Base.helpers.simple_format(raw[:product_details])
      end

      if raw[:short_description].present?
        processed[:short_description] = ActionController::Base.helpers.simple_format(raw[:short_description])
      end

      # :colors is the legacy color colors.
      # :recommended_colors will each have a variant built from them
      # :available_colors which are not :recommended_colors will get a ProductColorValue, but no variant.
      processed[:colors]             = get_color_options(raw[:colors]).map(&:name)
      recommended_colors             = get_color_options(raw[:colors])
      available_colors               = get_color_options(raw[:available_colors].to_s.split(','))
      processed[:recommended_colors] = recommended_colors
      processed[:available_colors]   = Set.new(available_colors + recommended_colors).to_a

      processed[:customizations] = []
      raw[:customizations].each do |customization|
        if customization[:name].present?
          processed[:customizations] << customization
        end
      end

      processed
    end

    private def get_color_options(color_names)
      Array.wrap(color_names).map(&:strip).map do |human_color_name|
        find_or_create_color_option(presentation: human_color_name)
      end
    end

    class ColorOptionValue < Struct.new(:id, :name, :presentation);
    end

    private def find_or_create_color_option(presentation:)
      color = Spree::OptionType.color.option_values.where('LOWER(presentation) = ?', presentation.downcase).first

      if color.blank?
        warn "Creating new Color option #{presentation}."
        color = Spree::OptionType.color.option_values.create do |object|
          object.name         = presentation.downcase.gsub(' ', '-')
          object.presentation = presentation
        end
      end

      ColorOptionValue.new(color.id, color.name, color.presentation)
    end

    private def build_item_hash(processed, raw)
      {
        # Basic
        sku:                processed[:sku] || raw[:sku],
        name:               processed[:name] || raw[:name],
        price_in_aud:       raw[:price_in_aud],
        price_in_usd:       raw[:price_in_usd],
        description:        processed[:description] || raw[:description],
        colors:             processed[:colors],
        style_profile:      {
          glam:           raw[:glam],
          girly:          raw[:girly],
          classic:        raw[:classic],
          edgy:           raw[:edgy],
          bohemian:       raw[:bohemian],
          sexiness:       raw[:sexiness],
          fashionability: raw[:fashionability],
          apple:          raw[:apple],
          pear:           raw[:pear],
          strawberry:     raw[:strawberry],
          hour_glass:     raw[:hour_glass],
          column:         raw[:column],
          athletic:       raw[:athletic],
          petite:         raw[:petite]
        },
        properties:         {
          style_notes:                raw[:style_notes],
          care_instructions:          raw[:care_instructions],
          size:                       raw[:size],
          fit:                        raw[:fit],
          fabric:                     raw[:fabric],
          product_type:               raw[:product_type],
          product_category:           raw[:product_category],
          factory_id:                 raw[:factory_id],
          factory_name:               raw[:factory_name],
          product_coding:             raw[:product_coding],
          shipping:                   raw[:shipping],
          stylist_quote_short:        raw[:stylist_quote_short],
          stylist_quote_long:         raw[:stylist_quote_long],
          product_details:            processed[:product_details],
          revenue:                    raw[:revenue],
          cogs:                       raw[:cogs],
          video_id:                   processed[:video_id],
          color_customization:        raw[:color_customization],
          short_description:          raw[:short_description],
          standard_days_for_making:   raw[:standard_days_for_making] || 5,
          customised_days_for_making: raw[:customised_days_for_making] || 10
        },
        song:               {
          link: raw[:song_link],
          name: raw[:song_name],
        },
        customizations:     processed[:customizations],
        recommended_colors: processed[:recommended_colors],
        available_colors:   processed[:available_colors],
      }
    end

    def get_column_indices(book)
      return @codes if @codes.present?

      book.default_sheet = book.sheets.first
      @codes             = {}

      conformities = {
        # Basic
        sku:                        /style #/i,
        name:                       /product name/i,
        description:                /description/i,
        # price_in_aud: /rrp/i,
        price_in_usd:               /price usd/i,
        taxons:                     /taxons?? \d+/i,
        colors:                     /(color|colour) \d+$/i,

        # Style Profile
        glam:                       /glam$/i,
        girly:                      /girly$/i,
        classic:                    /classic$/i,
        edgy:                       /edgy$/i,
        bohemian:                   /boho$/i,
        sexiness:                   /sexy/i,
        fashionability:             /fashion/i,
        apple:                      /apple/i,
        pear:                       /pear/i,
        strawberry:                 /strawberry/i,
        hour_glass:                 /hourglass|hourgalss/i,
        column:                     /column/i,
        athletic:                   /athletic/i,
        petite:                     /petite/i,
        # Properties
        style_notes:                /styling notes/i,
        care_instructions:          /care instructions/i,
        fit:                        /fit/i,
        size:                       /size/i,
        fabric:                     /fabric/i,
        product_type:               /product type/i,
        product_category:           /product category/i,
        factory_id:                 /factory id/i,
        factory_name:               /factory$/i,
        color_customization:        /colour customisation/i,
        available_colors:           /available colou?rs/i,
        #product_coding: /product coding/i,
        shipping:                   /shipping/i,
        stylist_quote_short:        /stylist inspiration quote/i,
        #stylist_quote_long: /expanded stylist quote/i,
        product_details:            /product details/i,
        short_description:          /short description/i,
        standard_days_for_making:   /standard days for making/i,
        customised_days_for_making: /customised days for making/i
      }

      conformities.each do |key, regex|
        indexes = []

        book.row(main_column_heading_row).each_with_index do |title, index|
          next unless title.present?

          if title.strip =~ regex
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

      @codes[:price_in_aud] = 4
      @codes[:price_in_usd] = 5
      @codes[:description]  = 6

      @codes[:customizations] = []
      book.row(main_column_heading_row).each_with_index do |title, index|
        next unless title =~ /customisation \#\d/i
        @codes[:customizations] << {
          name:  index + 1, #honestly wtf
          price: index + 2
        }
      end

      book.row(main_column_heading_row).each_with_index do |title, index|
        next unless title =~ /Music Track Link/i
        @codes[:song_link] = index + 1
        @codes[:song_name] = index + 2
      end


      @codes[:revenue]           = 135
      @codes[:cogs]              = 136
      @codes[:product_coding]    = 137
      @codes[:video_id]          = 139 # 138 139 with
      @codes[:short_description] = 140

      info "Found #{@codes.keys.count} keyed columns."
      @codes
    end

    def get_rows_indexes(book, columns)
      first_empty_row_num = first_content_row_number

      total_rows = book.last_row(book.sheets.first)
      while first_empty_row_num < total_rows and book.cell(first_empty_row_num, columns[:sku]).present?
        first_empty_row_num += 1
      end

      info "Found #{first_empty_row_num - first_content_row_number} rows of data."
      (first_content_row_number..first_empty_row_num)
    end

    # create product with restored data
    def update_products
      info 'Updating Products (active colors and fit attribute)'

      parsed_data.map do |attrs|
        args = attrs.symbolize_keys

        product = find_product(args)
        next if product.blank?

        # [x] deactivate product color values that exists
        # [x] create product color values that aren't related to the product yet
        # [x] Update model information

        add_product_properties(product, args[:properties].symbolize_keys)
        update_product_color_options(product, **args.slice(:available_colors))
      end
    end

    private

    def get_section_heading(sku:, name:)
      "[" << "#{sku} - #{name}".ljust(25) << "]"
    end

    def find_product(args)
      sku = args[:sku].to_s.downcase.strip
      raise 'SKU should be present!' unless sku.present?

      master = Spree::Variant.where(deleted_at: nil, is_master: true).where('LOWER(TRIM(sku)) = ?', sku).order('id DESC').first

      if master.blank?
        warn "Srpree::Variant with SKU: #{sku} DOES NOT exist!"
        return
      end

      master.product
    end

    def add_product_properties(product, args)
      debug "#{get_section_heading(sku: product.sku, name: product.name)} #{__method__}"
      allowed    = [:fit]
      properties = args.slice(*allowed).select { |_, value| value.present? }
      properties.each do |name, value|
        product.set_property(name, value)
      end
    end

    def update_product_color_options(spree_product, available_colors:)
      debug "#{get_section_heading(sku: spree_product.sku, name: spree_product.name)} #{__method__}"

      # [x] deactivate product color values that exists
      # [x] create product color values that aren't related to the product yet

      product_color_values = spree_product.product_color_values

      # Deactivate current product non custom colors
      product_color_values.where(custom: false).each do |product_color_value|
        product_color_value.active = false
        product_color_value.save!
      end

      # Convert custom colors to main colors
      available_colors.each do |available_color|
        if (custom_color = product_color_values.where(option_value_id: available_color.id, custom: true).first)
          custom_color.custom = false
          custom_color.save!
        end
      end

      # Create product colors (not custom)
      available_colors.each do |available_color|
        new_color        = product_color_values.where(option_value_id: available_color.id, custom: false).first_or_create
        new_color.active = true
        new_color.save!
      end
    end
  end
end
