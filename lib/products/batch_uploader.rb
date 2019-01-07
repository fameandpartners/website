# encoding: utf-8

require 'roo'
require 'ostruct'
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

#    include ActionView::Helpers::TextHelper # for truncate

    def initialize(available_on, mark_new_this_week = false, logdev: $stdout)
      @logger = Logger.new(logdev)
      @logger.level = Logger::INFO
#      @logger.formatter = LogFormatter.terminal_formatter

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

      color_data = build_color_data( book )
      @parsed_data = rows.to_a.map do |row_num|
        raw = extract_raw_row_data(book, columns, row_num)
        if ENV['PARAM1'].present? && raw[:sku] != ENV['PARAM1']
          puts "Master Product Sheet SKIP #{raw[:sku]} #{raw[:name]}"
          nil
        else
          puts "Master Product Sheet TAKE #{raw[:sku]} #{raw[:name]}"
          processed = process_raw_row_data(raw, color_data)
          item_hash = build_item_hash(processed, raw, color_data)
          item_hash
        end
      end
      @parsed_data.reject! { |x| x.nil? }
      add_cad_data( book, @parsed_data ) if cad_data_present?( book )
      info "Parse Complete"
    end

    def build_color_data( book )

      fabric_types = []
      color_data = {}
      book.row( 1, "Fabric & Color" ).each_slice(3) do |slice|
        fabric_types.push( slice.first.strip )
      end

      total_rows = book.last_row("Fabric & Color")
      (2..total_rows).each do |i|
        book.row( i, "Fabric & Color" ).each_slice(3).to_a.each_with_index do |slice, index|
          color_data[slice[1].strip] = { code: slice[1].strip, color_name: slice[0].strip, fabric_name: fabric_types[index].split( '(' ).first.strip, fabric_price: slice[2].present? ?  slice[2] : nil } if slice[0].present?
        end
      end
      color_data
    end

    def color_data_present?( book )
      !book.sheets.index( "Fabric & Color" ).nil?
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
        if ENV['PARAM1'].present? && current_style_number != ENV['PARAM1']
          puts "CADs Sheet           SKIP #{current_style_number}"
          next
        else
          puts "CADs Sheet           TAKE #{current_style_number}"
        end

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

      # Valid
      raw[:sku]                        = book.cell(row_num, columns[:sku])
      raw[:name]                       = book.cell(row_num, columns[:name])
      raw[:description]                = book.cell(row_num, columns[:description])
      raw[:price_in_aud]               = book.cell(row_num, columns[:price_in_aud])
      raw[:price_in_usd]               = book.cell(row_num, columns[:price_in_usd])
      raw[:taxons]                     = Array.wrap(columns[:taxons]).map { |i| book.cell(row_num, i) }.reject(&:blank?)
      raw[:fit]                        = book.cell(row_num, columns[:fit])
      raw[:height_mapping_count]       = book.cell(row_num, columns[:height_mapping_count]) || DEFAULT_HEIGHT_MAPPING_COUNT
      raw[:recommended_fabric_colors]  = book.cell(row_num, columns[:recommended_fabric_colors])
      raw[:fabric_information]         = Array.wrap(columns[:fabric_information]).map { |i| book.cell(row_num, i) }
      raw[:custom_fabric_colors]       = Array.wrap(columns[:custom_fabric_colors]).map { |i| book.cell(row_num, i) }
      raw[:customizations] = []
      columns[:customizations].each_with_index do |customization, index|
        raw[:customizations] << {
          name:     book.cell(row_num, customization[:name]).to_s.gsub("_x000D_", '').strip,
          price:    book.cell(row_num, customization[:price]).to_s.gsub(/[^\d\.]/, '').to_f,
          position: index + 1
        }
      end
      raw[:factory_name]               = book.cell(row_num, columns[:factory_name])
      raw[:product_category]           = book.cell(row_num, columns[:product_category])
      raw[:product_sub_category]       = book.cell(row_num, columns[:product_sub_category])

      #info "Row #{row_num} - Extracted Raw Data for SKU: #{raw[:sku]}"
      raw
    end

    private def process_raw_row_data(raw, color_data)
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

      range = (Spree::Taxonomy.where(name: 'Range').first || Spree::Taxonomy.first).root

      processed[:taxon_ids] = []
      raw[:taxons].select(&:present?).map(&:humanize).map(&:titleize).each do |taxon_name|
        taxon = Spree::Taxon.where("LOWER(REPLACE(name, '-', ' ')) = ?", taxon_name.downcase).first

        abort("Taxon '#{taxon_name}' does not exist on dress '#{raw[:name]}' (#{raw[:sku]})!  Upload aborted!") if taxon.blank?

        processed[:taxon_ids] << taxon.id
      end

      processed[:taxon_ids] << new_this_week_taxon_id if @mark_new_this_week && new_this_week_taxon_id.present?

      # Turn the different color codes into the their color maps
      recommended_fabric_color_codes = raw[:recommended_fabric_colors].split( ',' ).collect(&:strip)
      processed[:recommended_fabric_colors] = recommended_fabric_color_codes.map  {|color_code| lookup_color_code( color_code, color_data ) }
      processed[:custom_fabric_colors] = raw[:custom_fabric_colors].map do |custom_fabric_color|
        if( custom_fabric_color )
          custom_fabric_color_codes = custom_fabric_color.split( ',' ).collect(&:strip)
          custom_fabric_color_codes = custom_fabric_color_codes - recommended_fabric_color_codes
          custom_fabric_color_codes.map {|color_code| lookup_color_code( color_code, color_data ) }
        else
          nil
        end
      end

      processed[:customizations] = []
      raw[:customizations].each do |customization|
        if customization[:name].present?
          processed[:customizations] << customization
        end
      end
      processed
    end

    private def lookup_color_code( color_code, color_data )
      color_data[color_code.strip]
    end

    private def get_color_options(color_names)
      Array.wrap(color_names).map(&:strip).map do |human_color_name|
        find_or_create_color_option(presentation: human_color_name)
      end
    end

    class ColorOptionValue < Struct.new(:id, :name, :presentation); end

    private def find_or_create_fabric_color_option(presentation)
      fabric_color = Spree::OptionType.fabric_color.option_values.where('LOWER(presentation) = ?', presentation).first

      if( fabric_color.blank? )
        fabric_color = Spree::OptionType.fabric_color.option_values.create do |object|
          object.name         = presentation.downcase.gsub(' ', '-')
          object.presentation = presentation
        end
      end
      fabric_color
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

    private def build_item_hash(processed, raw, color_data)
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

        properties:     {
          height_mapping_count:       raw[:height_mapping_count],
          fit:                        raw[:fit],
          factory_name:               raw[:factory_name],
          product_details:            processed[:product_details],
        },
        customizations:     processed[:customizations],
        recommended_fabric_colors: processed[:recommended_fabric_colors],
        custom_fabric_colors: processed[:custom_fabric_colors],
        fabric_information: raw[:fabric_information],
        color_data: color_data
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
          recommended_fabric_colors:  /recommended.*fabric.*/im,
          fabric_information:         /fabric information \d+/i,
          custom_fabric_colors:       /custom fabric & color \d+/i,
          factory_name:               /factory$/i,
          product_category:           /product category/i,
          product_sub_category:       /product sub-category/i,
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
      products_attrs.reverse.map do |attrs|
        args = attrs.symbolize_keys

        begin
          # Makes the basic product andi it's variant
          product = create_or_update_product(args)

          # Not quite - Spree::OptionType.size.option_values.collect(&:name)
          sizes = %w(
            US0/AU4   US2/AU6   US4/AU8   US6/AU10  US8/AU12  US10/AU14
            US12/AU16 US14/AU18 US16/AU20 US18/AU22 US20/AU24 US22/AU26
          )

          add_product_properties(product, args[:properties].symbolize_keys)
          add_product_color_options(product, [args[:recommended_fabric_colors], *args[:custom_fabric_colors]].flatten)
          fabric_products = add_product_color_fabrics( product, args[:recommended_fabric_colors], args[:custom_fabric_colors], args[:fabric_information] )
          add_product_variants(product, sizes, fabric_products, args[:price_in_aud], args[:price_in_usd])
          add_product_customizations(product, args[:customizations] || [])
          add_product_layered_cads( product, args[:cads] || [] )
          add_product_height_ranges( product, args[:properties][:height_mapping_count].to_i )
          product
        end
      end.compact
    end

    private

    def add_product_color_fabrics( product, recommendend_fabric_colors, custom_fabric_colors, fabric_descriptions )
      product.fabric_products.each do |fp|
        fp.active = false
        fp.save
      end
      to_return = associate_fabrics_with_product( product, recommendend_fabric_colors, fabric_descriptions.first, true )
      custom_fabric_colors.each_with_index do |fabric_color, index|
        # You can't just compact because it screws up the indexing with the fabric descriptions
        puts "custom fabrics"
        to_return += associate_fabrics_with_product( product, fabric_color, fabric_descriptions[index], false ) unless fabric_color.nil?
      end

      to_return
    end

    private def find_or_create_fabric_and_update_fabric_prices( fabric_name, color_option, price )
      puts "Color: #{fabric_name} for #{price}"
      to_return = Fabric.find_by_material_and_option_value_id( fabric_name, color_option.id )
      presentation = "#{color_option.presentation} #{fabric_name}"

      fabric_color_option = find_or_create_fabric_color_option( presentation )
      if( to_return.nil? )
        to_return = Fabric.create do |object|
          object.material = fabric_name
          object.option_value_id = color_option.id
          object.presentation = presentation
          object.name = object.presentation.parameterize
          object.option_fabric_color_value = fabric_color_option
          object.price_aud = price
          object.price_usd = price
        end
      else
        # Clean up legacy fabrics
        if( to_return.option_fabric_color_value.nil? )
          to_return.option_fabric_color_value = fabric_color_option
          to_return.save
        end

        if( price.present? )
          to_return.price_aud = price
          to_return.price_usd = price
          to_return.save
        end
      end

      to_return
    end

    private def find_or_create_fabrics_product( fabric, product, fabric_descriptions, recommended )
      to_return = FabricsProduct.find_by_fabric_id_and_product_id( fabric.id, product.id )
      unless( to_return.present? )
        to_return = FabricsProduct.create do |object|
          object.fabric_id = fabric.id
          object.product_id = product.id
          object.active = true
        end

        to_return.recommended = recommended
        to_return.description = fabric_descriptions
        to_return.save
      end
      to_return
    end

    private def associate_fabrics_with_product( product, fabric_colors, fabric_description, recommended )
      to_return = []
      # How am I going to clean this up?
      fabric_colors.each do |fabric_color|

        unless fabric_color.nil? || fabric_color.empty?
          fabric_name = fabric_color[:fabric_name]
          fabric_price = fabric_color[:fabric_price].present? ? fabric_color[:fabric_price].to_i : nil
          color_option = get_color_options( [fabric_color[:color_name]] ).first
          fabric  = find_or_create_fabric_and_update_fabric_prices( fabric_name, color_option, fabric_price )
          fabric_product = find_or_create_fabrics_product( fabric, product, fabric_description, recommended )
          to_return << fabric_product
        end
      end

      to_return
    end

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
      info "Processing Cads"
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


    def add_product_color_options(product, colors )
      debug "#{get_section_heading(sku: product.sku, name: product.name)} #{__method__}"

      color_names = (colors.compact.collect {|color_map| color_map[:color_name] }).uniq
      color_options = get_color_options( color_names)
      color_options.map do |recommended|
        product.product_color_values.where(option_value_id: recommended.id, custom: false).first_or_create
      end

      # cleanup old color options
      product.product_color_values.where(custom: false).where('option_value_id NOT IN (?)', color_options.map(&:id)).destroy_all
    end

    def add_product_variants(product, sizes, fabric_products, price_in_aud, price_in_usd)
      debug "#{get_section_heading(sku: product.sku, name: product.name)} #{__method__}"
      variants = []
      size_option = Spree::OptionType.size
      fabric_option = Spree::OptionType.fabric_color
      product.option_types = [size_option, fabric_option]
      product.save

      product.reload
      sizes_to_process = sizes.clone

      threads = []
      number_of_threads = 1
      semaphore = Mutex.new

      (1..number_of_threads).each do |thread_num|
        threads << Thread.new do
          size_name = "start"
          while( size_name != nil ) do
            semaphore.synchronize do
              unless( sizes_to_process.empty? )
                size_name = sizes_to_process.pop
              else
                size_name = nil
              end
            end
            unless size_name.nil?
              puts "Thread # #{thread_num} processing #{size_name}"
              fabric_products.each do |fabrics_product|

                size_value  = size_option.option_values.where(name: size_name).first
                fabric_color = fabrics_product.fabric.option_fabric_color_value

                next if size_value.blank? || fabric_color.blank?

                variant =  product.variants.includes( :option_values ).where( 'spree_option_values.id' =>  fabric_color.id).detect do |variant|
                  [size_value.id, fabric_color.id].all? do |id|
                    variant.reload.option_value_ids.include?(id)
                  end
                end


                variant = variant.reload unless variant.nil?
                unless variant.present?
                  variant = product.variants.build
                  variant.option_values = [size_value, fabric_color]
                end

                # Avoids errors with Spree hooks updating lots and lots of orders.
                # See: spree/core/app/models/spree/variant.rb:146 #on_demand=
                variant.send :write_attribute, :on_demand, true
                Spree::Variant.skip_callback( :save, :after, :recalculate_product_on_hand )
                Spree::Variant.skip_callback( :save, :after, :process_backorders )

                begin
                  variant.save( :validate => false )
                rescue Exception => e
                  puts "Got exception "
                  puts e
                  variant.save(:validate => false )
                end


                if price_in_aud.present?
                  aud = Spree::Price.find_or_create_by_variant_id_and_currency(variant.id, 'AUD')
                  aud.amount = price_in_aud + fabrics_product.fabric.price_aud.to_f
                  aud.save!
                end

                if price_in_usd.present?
                  usd = Spree::Price.find_or_create_by_variant_id_and_currency(variant.id, 'USD')
                  usd.amount = price_in_usd+ fabrics_product.fabric.price_usd.to_f
                  usd.save!
                end

                semaphore.synchronize do
                  variants.push(variant.id) if variant.persisted?
                end
              end
            end
          end
        end
      end
      threads.each do |thread|
        thread.join
      end
      variants
      product.variants.where('id NOT IN (?)', variants).update_all(deleted_at: Time.now)
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
        customization.save( validate: false )
        customizations.push(customization)
      end

      customizations
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
