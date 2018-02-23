# encoding: utf-8

require 'roo'
require 'ostruct'
require 'log_formatter'

# TODO - MORE REFACTORING
# This class contains multiple responsibilities inside it.
# i.e.
#  - Loading the file & extracting the raw data
#  - Preprocessing the data
#  - Validating the data - This is not explicitly done, but in a few places the code will raise errors on missing data.
#  - Transforming the data into a simple interchange format, in this case it's a Hash.
#  - Building & saving the domain models.
#      There are 7 methods which take a Spree::Product `product` as the first parameter, this is
#      definitely pointing to a class lurking in there somewhere.

module Products
  class BatchUploader
    extend Forwardable
    DEFAULT_HEIGHT_MAPPING_COUNT = 3
    def_delegators :@logger, :info, :debug, :warn, :error, :fatal

    attr_reader :parsed_data, :keep_taxons, :available_on

    include ActionView::Helpers::TextHelper # for truncate

    def initialize(available_on, mark_new_this_week = false, logdev: $stdout)
      @logger = Logger.new(logdev)
      @logger.level = Logger::INFO
      @logger.formatter = LogFormatter.terminal_formatter

      @available_on = available_on
      @keep_taxons = true
      self.mark_new_this_week = mark_new_this_week
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

    def has_cad_data?( file_path )
      cad_data_present?( load_excel_book( file_path ) )
    end

    def new_this_week_taxon_id
      Spree::Taxon.where(name: 'New This Week').first.try(:id)
    end

    def parse_file(file_path)
      info "Loading Excel File #{file_path}"
      return if file_path.nil?

      book = load_excel_book( file_path )

      book.default_sheet = book.sheets.first
      columns            = get_column_indices(book)
      rows               = get_rows_indexes(book, columns)

      info "Parsing Data into Hash"

      @parsed_data = rows.to_a.map do |row_num|
        raw = extract_raw_row_data(book, columns, row_num)
        processed = process_raw_row_data(raw)
        item_hash = build_item_hash(processed, raw)
      end
      add_cad_data( book, @parsed_data ) if cad_data_present?( book )

      info "Parse Complete"
    end

    def add_cad_data( book, parsed_data )
      total_rows = book.last_row("CADs")
      columns = {}
      style_data = {}

      (1..book.last_column( "CADs" )).each do |i|
        columns[book.cell( 1, i, "CADs" ).parameterize.underscore] = i
      end

      (2..total_rows).each do |i|
        current_row = book.row( i, "CADs" )
        current_style_number = current_row[columns["style"] - 1].strip
        style_data[current_style_number] = [] if style_data[current_style_number].nil?
        style_array = style_data[current_style_number]
        customizations_enabled_for = [map_to_true_or_false( current_row[columns["customisation_1"] - 1] ),
                                      map_to_true_or_false( current_row[columns["customisation_2"] - 1] ),
                                      map_to_true_or_false( current_row[columns["customisation_3"] - 1] ),
                                      map_to_true_or_false( current_row[columns["customisation_4"] - 1] )]

        style_array << {customizations_enabled_for: customizations_enabled_for,
                        base_image_name: current_row[columns["base_image_name"] - 1] ,
                        layer_image_name: current_row[columns["layer_image"] - 1],
                        width: current_row[columns["width"] - 1],
                        height: current_row[columns["height"] - 1]
        }

      end
      parsed_data.each do |style|
        style[:cads] = style_data[style[:sku].strip]
      end
    end

    def map_to_true_or_false( value )
      value == "Selected"
    end

    def load_excel_book( file_path )
      if file_path =~ /\.xls$/
        Roo::Excel.new(file_path, false, :warning)
      elsif file_path =~ /\.xlsx$/
        # false - packed, warning - ignore not xslx format
        Roo::Excelx.new(file_path, false, :warning)
      else
        raise 'Invalid file type'
      end
    end

    def cad_data_present?(book)
      !book.sheets.index( "CADs" ).nil?
    end


    private def extract_raw_row_data(book, columns, row_num)
      raw                = {}

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
      raw[:height_mapping_count]       = book.cell(row_num, columns[:height_mapping_count]) || DEFAULT_HEIGHT_MAPPING_COUNT
      raw[:fabric]                     = book.cell(row_num, columns[:fabric])
      raw[:product_type]               = book.cell(row_num, columns[:product_type])
      raw[:product_category]           = book.cell(row_num, columns[:product_category])
      raw[:product_sub_category]       = book.cell(row_num, columns[:product_sub_category])
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

      range = (Spree::Taxonomy.where(name: 'Range').first || Spree::Taxonomy.first).root

      processed[:taxon_ids] = []
      raw[:taxons].select(&:present?).map(&:humanize).map(&:titleize).each do |taxon_name|
        taxon = Spree::Taxon.where("LOWER(REPLACE(name, '-', ' ')) = ?", taxon_name.downcase).first

        abort("Taxon '#{taxon_name}' does not exist on dress '#{raw[:name]}' (#{raw[:sku]})!  Upload aborted!") if taxon.blank?

        processed[:taxon_ids] << taxon.id
      end

      processed[:taxon_ids] << new_this_week_taxon_id if @mark_new_this_week && new_this_week_taxon_id.present?

      # :colors is the legacy recommended colors.
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

    class ColorOptionValue < Struct.new(:id, :name, :presentation); end

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
        sku:            processed[:sku] || raw[:sku],
        name:           processed[:name] || raw[:name],
        price_in_aud:   raw[:price_in_aud],
        price_in_usd:   raw[:price_in_usd],
        description:    processed[:description] || raw[:description],
        colors:         processed[:colors],
        taxon_ids:      processed[:taxon_ids],
        category: raw[:product_category],
        sub_category: raw[:product_sub_category],
        
        style_profile:  {
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
        properties:     {
          style_notes:                raw[:style_notes],
          care_instructions:          raw[:care_instructions],
          size:                       raw[:size],
          height_mapping_count:       raw[:height_mapping_count],
          fit:                        raw[:fit],
          fabric:                     raw[:fabric],
          product_type:               raw[:product_type],
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
        song:           {
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
      @codes = {}

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
          product_sub_category:       /product sub-category/i,
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
          customised_days_for_making: /customised days for making/i,
          height_mapping_count: /height mapping count/i

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
      @codes[:description] = 6

      @codes[:customizations] = []
      book.row(main_column_heading_row).each_with_index do |title, index|
        next unless title =~ /customisation \#\d/i
          @codes[:customizations] << {
            name: index + 1, #honestly wtf
            price: index + 2
          }
      end

      book.row(main_column_heading_row).each_with_index do |title, index|
        next unless title =~ /Music Track Link/i
        @codes[:song_link]      = index + 1
        @codes[:song_name]      = index + 2
      end


      @codes[:revenue]        = 135
      @codes[:cogs]           = 136
      @codes[:product_coding] = 137
      @codes[:video_id]       = 139 # 138 139 with
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
    def create_or_update_products(products_attrs)
      info "Creating or Update Products"
      products_attrs.map do |attrs|
        args = attrs.symbolize_keys

        begin
          product = create_or_update_product(args)

          # Not quite - Spree::OptionType.size.option_values.collect(&:name)
          sizes = %w(
            US0/AU4   US2/AU6   US4/AU8   US6/AU10  US8/AU12  US10/AU14
            US12/AU16 US14/AU18 US16/AU20 US18/AU22 US20/AU24 US22/AU26
          )

          add_product_properties(product, args[:properties].symbolize_keys)
          add_product_color_options(product, **args.slice(:available_colors, :recommended_colors))
          add_product_variants(product, sizes, args[:colors] || [], args[:price_in_aud], args[:price_in_usd])
          add_product_style_profile(product, args[:style_profile].symbolize_keys)
          add_product_customizations(product, args[:customizations] || [])
          add_product_song(product, args[:song].symbolize_keys || {})
          add_product_layered_cads( product, args[:cads] || [] )
          add_product_height_ranges( product, args[:properties][:height_mapping_count].to_i )

          product
        end
      end.compact
    end

    private

    def get_section_heading(sku:, name:)
      "[" << "#{sku} - #{name}".ljust(25) << "]"
    end

    def create_or_update_product(args)
      sku = args[:sku].to_s.downcase.strip
      section_heading = get_section_heading(sku: args[:sku], name: args[:name])
      info "#{section_heading} Building #{sku}"

      raise 'SKU should be present!' unless sku.present?

      master = Spree::Variant.where(deleted_at: nil, is_master: true).where('LOWER(TRIM(sku)) = ?', sku).order('id DESC').first

      product = master.try(:product)

      if product.blank?

        product = Spree::Product.new(sku: sku, featured: false, on_demand: true, available_on: @available_on)
      end

      taxon_ids = args[:taxon_ids] || []

      #FUCK YEAH HACKING
      if keep_taxons
        taxon_ids = taxon_ids | product.taxons.collect(&:id)
      end

      category = Category.find_by_category_and_subcategory( args[:category], args[:sub_category] )
      if( category.nil? )
        raise "No category matching #{args[:category]} / #{args[:sub_category]}"
      end
      
      attributes = {
        name: args[:name],
        price: args[:price_in_aud],
        description: args[:description],
        taxon_ids: taxon_ids,
        category_id: category.id,
        available_on: @available_on || product.available_on
      }

      edits = Spree::Taxonomy.find_by_name('Edits') || Spree::Taxonomy.find_by_id(8)
      
      if product.persisted?
        attributes[:taxon_ids] += product.taxons.where(taxonomy_id: edits.try(:id)).map(&:id)
      end

      attributes.select!{ |name, value| value.present? }

      product.assign_attributes(attributes, without_protection: true)

      if attributes[:name].present?
        if product.persisted?
          if product.valid? && product.name_was.downcase != attributes[:name].downcase
            product.save_permalink(attributes[:name].downcase.gsub(/\s/, '_'))
            product.assign_attributes(attributes, without_protection: true)
          end
        else
          product.permalink = attributes[:name].downcase.gsub(/\s/, '_')
        end
      end

      # need to save first to get a product_id since product_making_option requires it
      product.save!

      #add slow making
      prdmo = ProductMakingOption.new(  {product_id: product.id,
                                        active: true,
                                        option_type: 'slow_making',
                                        price: -0.1,
                                        currency: 'USD'},
                                        without_protection: true
                                      )
      # only connect the 2 if not already done before
      if prdmo.save
        product.making_options << prdmo
      end

      new_product = product.persisted? ? 'Updated' : 'Created'

      product.save!

      if args[:price_in_aud].present? || args[:price_in_usd].present?
        add_product_prices(product, args[:price_in_aud], args[:price_in_usd])
      end
      info "#{section_heading} #{new_product} id=#{product.id}"
      product
    end

    def add_product_layered_cads( product, cads )
      info "Processing Cads #{cads}"
      product.layer_cads = []
      cads.each_with_index do |cad, index|
        product.layer_cads << LayerCad.new( {position: index + 1}.merge( cad ) )
      end
    end

    def add_product_properties(product, args)
      debug "#{get_section_heading(sku: product.sku, name: product.name)} #{__method__}"
      allowed = [:style_notes,
                 :care_instructions,
                 :size,
                 :fit,
                 :fabric,
                 :product_type,
                 :product_category,
                 :factory_id,
                 :factory_name,
                 :product_coding,
                 :shipping,
                 :stylist_quote_short,
                 :stylist_quote_long,
                 :product_details,
                 :revenue,
                 :cogs,
                 :video_id,
                 :color_customization,
                 :standard_days_for_making,
                 :customised_days_for_making,
                 :short_description]

      properties = args.slice(*allowed).select{ |name, value| value.present? }

      properties.each do |name, value|
        product.set_property(name, value)
      end

      if factory = Factory.find_by_name(args[:factory_name].try(:capitalize))
        product.factory = factory
      end

      product
    end

    def add_product_height_ranges( product, height_mapping_count )
      master_variant = product.master
      master_variant.style_to_product_height_range_groups = []
      product_height_groups = []

      if( height_mapping_count == 3 )
        product_height_groups = ProductHeightRangeGroup.default_three
      elsif( height_mapping_count == 6 )
        product_height_groups = ProductHeightRangeGroup.default_six
      else
        raise "Unknown height mapping count"
      end

      product_height_groups.each { |phg| master_variant.style_to_product_height_range_groups << StyleToProductHeightRangeGroup.new( product_height_range_group: phg ) }

      master_variant.save
    end


    def add_product_color_options(product, recommended_colors:, available_colors:)
      debug "#{get_section_heading(sku: product.sku, name: product.name)} #{__method__}"
      custom_colors = available_colors - recommended_colors

      custom_colors.map do |custom|
        c = product.product_color_values.where(option_value_id: custom.id, custom: true).first_or_create
        c.active = true
        c.save!
      end

      recommended_colors.map do |recommended|
        product.product_color_values.where(option_value_id: recommended.id, custom: false).first_or_create
      end

      product.product_color_values.where(custom: false).where('option_value_id NOT IN (?)', recommended_colors.map(&:id)).destroy_all
    end

    def add_product_variants(product, sizes, colors, price_in_aud, price_in_usd)
      debug "#{get_section_heading(sku: product.sku, name: product.name)} #{__method__}"
      variants = []
      size_option = Spree::OptionType.size
      color_option = Spree::OptionType.color

      product.option_types = [size_option, color_option]
      product.save

      product.reload

      sizes.each do |size_name|
        colors.each do |color_name|
          size_value  = size_option.option_values.where(name: size_name).first
          color_value = color_option.option_values.where('LOWER(name) = ?', color_name.downcase).first

          next if size_value.blank? || color_value.blank?

          variant = product.variants.detect do |variant|
            [size_value.id, color_value.id].all? do |id|
              variant.option_value_ids.include?(id)
            end
          end

          unless variant.present?
            variant = product.variants.build
            variant.option_values = [size_value, color_value]
          end

          # Avoids errors with Spree hooks updating lots and lots of orders.
          # See: spree/core/app/models/spree/variant.rb:146 #on_demand=
          variant.send :write_attribute, :on_demand, true

          variant.save

          if price_in_aud.present?
            aud = Spree::Price.find_or_create_by_variant_id_and_currency(variant.id, 'AUD')
            aud.amount = price_in_aud
            aud.save!
          end

          if price_in_usd.present?
            usd = Spree::Price.find_or_create_by_variant_id_and_currency(variant.id, 'USD')
            usd.amount = price_in_usd
            usd.save!
          end

          variants.push(variant) if variant.persisted?
        end
      end

      variants

      product.variants.where('id NOT IN (?)', variants.map(&:id)).update_all(deleted_at: Time.now)
    end

    def add_product_customizations(product, array_of_attributes)
      debug "#{get_section_heading(sku: product.sku, name: product.name)} #{__method__}"
      customizations = []

      allowed = [:name,
                 :price,
                 :position]

      array_of_attributes.each do |raw_attrs|
        attrs = raw_attrs.symbolize_keys.slice(*allowed)

        next unless attrs.values.any?(&:present?)

        attrs[:presentation] = attrs[:name].titleize
        attrs[:name] = attrs[:name].downcase.gsub(' ', '-')
        attrs[:price] = 0 unless attrs[:price].present?

        customization = product.customisation_values.where(position: attrs[:position]).first

        if customization.blank?
          customization = product.customisation_values.build
        end

        customization.update_attributes(attrs, without_protection: true)

        customizations.push(customization)
      end

      customizations
    end

    def add_product_style_profile(product, args)
      debug "#{get_section_heading(sku: product.sku, name: product.name)} #{__method__}"
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
                              :petite).select{ |name, value| value.present? }

      attributes.each do |key, value|
        attributes[key] = value.to_s.to_i
      end

      basic_style_names = [:glam, :girly, :classic, :edgy, :bohemian]
      total = 0
      factor = attributes.slice(*basic_style_names).values.sum / 10.0

      unless factor.eql?(0.0)
        basic_style_names.each do |style_name|
          points = (attributes[style_name].to_i / factor).round

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

    def add_product_song(product, raw_attrs)
      debug "#{get_section_heading(sku: product.sku, name: product.name)} #{__method__}"
      if raw_attrs[:link].present?
        song = product.inspirations.song.first || product.inspirations.song.build

        song.update_attributes(content: raw_attrs[:link], name: raw_attrs[:name])
      end
    end

    def add_product_prices(product, price, us_price = nil)
      debug "#{get_section_heading(sku: product.sku, name: product.name)} #{__method__}"
      product.price = price
      product.save

      master_variant = product.master

      usd = Spree::Price.find_or_create_by_variant_id_and_currency(master_variant.id, 'USD')
      usd.amount = us_price if us_price.present?
      usd.save!
    end

    private def mark_new_this_week=(value)
      if value
        warn 'New products will have new_this_week taxon'
      else
        warn 'New products will NOT have new_this_week taxon!'
      end
      @mark_new_this_week = value
    end
  end
end
