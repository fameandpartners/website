require 'ostruct'
require 'roo'

module Products
  class BatchUploader
    attr_reader :parsed_data

    include ActionView::Helpers::TextHelper # for truncate

    def initialize
      @@titles_row_numbers = [8, 10, 11, 12]
      @@first_content_row_number = 13
    end

    def parse_file(filedata, from = 0)
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

      from = Integer(from)

      book.default_sheet = book.sheets.first

      columns = get_columns_codes(book)
      rows = get_rows_indexes(book, columns)

      book.default_sheet = book.sheets.first

      rows.to_a.from(from).to(9).each do |row_num|
        raw = {}

        # Basic
        raw[:sku]                 = book.cell(row_num, columns[:sku])
        raw[:name]                = book.cell(row_num, columns[:name])
        raw[:description]         = book.cell(row_num, columns[:description])
        raw[:price_in_aud]        = book.cell(row_num, columns[:price_in_aud])
        raw[:price_in_usd]        = book.cell(row_num, columns[:price_in_usd])
        raw[:taxons]              = Array.wrap(columns[:taxons]).map{|i| book.cell(row_num, i) }.reject(&:blank?)
        raw[:colors]              = Array.wrap(columns[:colors]).map{|i| book.cell(row_num, i) }.reject(&:blank?).map{|i| i.downcase.gsub(' ', '-') }
        # Style
        raw[:glam]                = book.cell(row_num, columns[:glam])
        raw[:girly]               = book.cell(row_num, columns[:girly])
        raw[:classic]             = book.cell(row_num, columns[:classic])
        raw[:edgy]                = book.cell(row_num, columns[:edgy])
        raw[:bohemian]            = book.cell(row_num, columns[:bohemian])
        raw[:sexiness]            = book.cell(row_num, columns[:sexiness])
        raw[:fashionability]      = book.cell(row_num, columns[:fashionability])
        raw[:apple]               = book.cell(row_num, columns[:apple])
        raw[:pear]                = book.cell(row_num, columns[:pear])
        raw[:strawberry]          = book.cell(row_num, columns[:strawberry])
        raw[:hour_glass]          = book.cell(row_num, columns[:hour_glass])
        raw[:column]              = book.cell(row_num, columns[:column])
        raw[:athletic]            = book.cell(row_num, columns[:athletic])
        raw[:petite]              = book.cell(row_num, columns[:petite])
        # Properties
        raw[:style_notes]         = book.cell(row_num, columns[:style_notes])
        raw[:fit]                 = book.cell(row_num, columns[:fit])
        raw[:fabric]              = book.cell(row_num, columns[:fabric])
        raw[:product_type]        = book.cell(row_num, columns[:product_type])
        raw[:product_category]    = book.cell(row_num, columns[:product_category])
        raw[:factory_id]          = book.cell(row_num, columns[:factory_id])
        raw[:factory_name]        = book.cell(row_num, columns[:factory_name])
        raw[:product_coding]      = book.cell(row_num, columns[:product_coding])
        raw[:shipping]            = book.cell(row_num, columns[:shipping])
        raw[:stylist_quote_short] = book.cell(row_num, columns[:stylist_quote_short])
        raw[:stylist_quote_long]  = book.cell(row_num, columns[:stylist_quote_long])
        raw[:product_details]     = book.cell(row_num, columns[:product_details])
        raw[:revenue]             = book.cell(row_num, columns[:revenue])
        raw[:cogs]                = book.cell(row_num, columns[:cogs])

        # Additional
        raw[:perfume_link]        = book.cell(row_num, columns[:perfume_link])
        raw[:perfume_name]        = book.cell(row_num, columns[:perfume_name])
        raw[:perfume_brand]       = book.cell(row_num, columns[:perfume_brand])
        raw[:song_link]           = book.cell(row_num, columns[:song_link])

        raw[:recommendations]     = {}
        columns[:recommendations].each do |style, recommendations|
          raw[:recommendations][style] ||= []
          recommendations.each_with_index do |recommendation, index|
            raw[:recommendations][style] << {
              name: book.cell(row_num, recommendation[:name]),
              description: book.cell(row_num, recommendation[:description]),
              price: book.cell(row_num, recommendation[:price]),
              link: book.cell(row_num, recommendation[:link]),
              position: index + 1
            }
          end
        end

        raw[:customizations]      = []
        columns[:customizations].each_with_index do |customization, index|
          raw[:customizations] << {
            name: book.cell(row_num, customization[:name]),
            price: book.cell(row_num, customization[:price]),
            position: index + 1
          }
        end

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

        range = (Spree::Taxonomy.where(name: 'Range').first || Spree::Taxonomy.first).root

        processed[:taxon_ids] = []
        raw[:taxons].each do |taxon_name|
          taxon = Spree::Taxon.where('LOWER(name) = ?', taxon_name.downcase).first

          taxon = range.children.create(name: taxon_name) unless taxon.present?

          processed[:taxon_ids] << taxon.id
        end

        processed[:customizations] = []
        raw[:customizations].each do |customization|
          if customization[:name].present?
            processed[:customizations] << customization
          end
        end

        processed[:recommendations] = {}
        raw[:recommendations].each do |style, recommendations|
          processed[:recommendations][style] = []

          recommendations.each do |recommendation|
            if recommendation[:name].present? || recommendation[:link].present?
              processed[:recommendations][style] << recommendation
            end
          end
        end

        item = OpenStruct.new(
          # Basic
          sku:                  processed[:sku] || raw[:sku],
          name:                 processed[:name] || raw[:name],
          price_in_aud:         raw[:price_in_aud],
          description:          processed[:description] || raw[:description],
          colors:               raw[:colors],
          taxon_ids:            processed[:taxon_ids],
          # Style Profile   
          glam:                 raw[:glam],
          girly:                raw[:girly],
          classic:              raw[:classic],
          edgy:                 raw[:edgy],
          bohemian:             raw[:bohemian],
          sexiness:             raw[:sexiness],
          fashionability:       raw[:fashionability],
          apple:                raw[:apple],
          pear:                 raw[:pear],
          strawberry:           raw[:strawberry],
          hour_glass:           raw[:hour_glass],
          column:               raw[:column],
          athletic:             raw[:athletic],
          petite:               raw[:petite],
          # Properties
          style_notes:          raw[:style_notes],
          fit:                  raw[:fit],
          fabric:               raw[:fabric],
          product_type:         raw[:product_type],
          product_category:     raw[:product_category],
          factory_id:           raw[:factory_id],
          factory_name:         raw[:factory_name],
          product_coding:       raw[:product_coding],
          shipping:             raw[:shipping],
          stylist_quote_short:  raw[:stylist_quote_short],
          stylist_quote_long:   raw[:stylist_quote_long],
          product_details:      raw[:product_details],
          revenue:              raw[:revenue],
          cogs:                 raw[:cogs],
          # Additional
          perfume_link:         raw[:perfume_link],
          perfume_name:         raw[:perfume_name],
          perfume_brand:        raw[:perfume_brand],
          song_link:            raw[:song_link],
          customizations:       processed[:customizations],
          recommendations:      processed[:recommendations]
        )

        @parsed_data.push(item)
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
        # price_in_aud: /rrp/i,
        price_in_usd: /price usd/i,
        taxons: /taxons? \d+/i,
        colors: /(color|colour) \d+$/i,
        # Style Profile
        glam: /glam$/i,
        girly: /girly$/i,
        classic: /classic$/i,
        edgy: /edgy$/i,
        bohemian: /boho$/i,
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
        factory_name: /factory$/i,
        #product_coding: /product coding/i,
        shipping: /shipping/i,
        stylist_quote_short: /stylist inspiration quote/i,
        stylist_quote_long: /expanded stylist quote/i,
        product_details: /product details/i
      }

      conformities.each do |key, regex|
        indexes = []

        book.row(@@titles_row_numbers.second).each_with_index do |title, index|
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

      @codes[:price_in_aud] = 3

      @codes[:customizations] = []

      start = 22
      3.times do |time|
        @codes[:customizations] << {
          name: start,
          price: start + 1
        }
        start += 2
      end

      @codes[:perfume_link] = 28
      @codes[:perfume_name] = 29
      @codes[:perfume_brand] = 30

      @codes[:song_link] = 31

      @codes[:recommendations] = {}
      @codes[:recommendations][:edgy] = []
      @codes[:recommendations][:bohemian] = []
      @codes[:recommendations][:glam] = []
      @codes[:recommendations][:girly] = []
      @codes[:recommendations][:classic] = []

      start = 35

      [:edgy, :bohemian, :glam, :girly, :classic].each_with_index do |style, index|
        4.times do |time|
          @codes[:recommendations][style] << {
            name: start + (time * 4),
            description: start + 1 + (time * 4),
            price: start + 2 + (time * 4),
            link: start + 3 + (time * 4)
          }
        end

        start += 16
      end

      @codes[:revenue] = 131
      @codes[:cogs] = 132
      @codes[:product_coding] = 133
      @codes[:price_in_aud] = 4

      @codes
    end

    def get_rows_indexes(book, columns)
      first_empty_row_num = @@first_content_row_number

      total_rows = book.last_row(book.sheets.first)
      while first_empty_row_num < total_rows and book.cell(first_empty_row_num, columns[:sku]).present?
        first_empty_row_num += 1
      end

      (@@first_content_row_number...first_empty_row_num)
    end

    # create product with restored data
    def create_or_update_products(products_attrs)
      products_attrs.map do |attrs|
        args = attrs.symbolize_keys

        begin
          product = create_or_update_product(args.merge!(
            sizes: %W{4 6 8 10 12 14 16}
          ))

          add_product_properties(product, args[:properties].symbolize_keys)
          add_product_variants(product, args[:sizes], args[:colors] || [])
          add_product_style_profile(product, args[:style_profile].symbolize_keys)
          add_product_customizations(product, args[:customizations] || {})
          add_product_accessories(product, args[:recommendations] || {})
          add_product_song(product, args[:song].symbolize_keys || {})
          add_product_perfume(product, args[:perfume].symbolize_keys || {})

          product
        rescue Exception => message
          Rails.logger.warn(message)
          nil
        end
      end.compact
    end

    private

    def create_or_update_product(args)
      sku = args[:sku].to_s.downcase

      raise 'SKU should be present!' unless sku.present?

      product = Spree::Variant.where(['is_master = ? AND LOWER(sku) = ?', true, sku]).first.try(:product)

      if product.blank?
        product = Spree::Product.new(sku: sku, featured: false, on_demand: true)
      end

      attributes = {
        name: args[:name],
        price: args[:price_in_aud],
        description: args[:description],
        taxon_ids: args[:taxon_ids] || []
      }

      attributes.select!{ |name, value| value.present? }

      product.assign_attributes(attributes, without_protection: true)

      if product.persisted? && product.valid?
        unless product.name_was.downcase == attributes[:name].downcase
          product.save_permalink(attributes[:name].downcase.gsub(/\s/, '_'))
        end
      else
        product.permalink = attributes[:name].downcase.gsub(/\s/, '_')
      end

      product.save!

      if args[:price_in_aud].present? && args[:price_in_usd].present?
        add_product_prices(product, args[:price_in_aud], args[:price_in_usd])
      end

      product
    end

    def add_product_properties(product, args)
      allowed = [:style_notes,
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
                 :cogs]

      properties = args.slice(*allowed).select{ |name, value| value.present? }

      properties.each do |name, value|
        product.set_property(name, value)
      end

      product
    end

    def add_product_variants(product, sizes, colors)
      variants = []
      size_option = Spree::OptionType.where(name: 'dress-size').first
      color_option = Spree::OptionType.where(name: 'dress-color').first

      product.option_types = [size_option, color_option]
      product.save

      product.reload

      sizes.each do |size_name|
        colors.each do |color_name|
          size_value  = size_option.option_values.where(name: size_name).first
          color_value = color_option.option_values.where(name: color_name).first

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

          variant.on_demand = true
          variant.price = product.price

          variant.save

          variants.push(variant)
        end
      end

      variants
    end

    def add_product_customizations(product, hash_of_attributes)

      customizations = []

      allowed = [:name,
                 :price,
                 :position]

      hash_of_attributes.values.each do |raw_attrs|
        attrs = raw_attrs.symbolize_keys.slice(*allowed)

        next unless attrs.values.any?(&:present?)

        attrs[:presentation] = attrs[:name].titleize
        attrs[:name] = attrs[:name].downcase.gsub(' ', '-')
        attrs[:price] = 0 unless attrs[:price].present?

        customizations.push(product.customisation_values.create(attrs, without_protection: true))
      end

      customizations
    end

    def add_product_accessories(product, accessories_by_style)
      allowed = [:name, :description, :price, :link, :position]

      accessories_by_style.each do |style_name, accessories|
        style = Style.where('LOWER(name) = ?', style_name.to_s.downcase).first

        next unless style.present?

        accessories.values.each do |accessory|
          product.accessories.create do |object|
            object.style = style
            object.name = accessory[:name]
            object.title = accessory[:description]
            object.price = accessory[:price]
            object.source = accessory[:link]
            object.position = accessory[:position]
          end
        end
      end
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
                              :petite).select{ |name, value| value.present? }

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

    def add_product_song(product, raw_attrs)
      if raw_attrs[:link].present?
        product.moodboard_items.song.create(content: raw_attrs[:link])
      end
    end

    def add_product_perfume(product, raw_attrs)
      allowed = [:name,
                 :brand,
                 :link]

      attrs = raw_attrs.slice(*allowed).select{ |name, value| value.present? }

      if attrs.any?
        product.moodboard_items.parfume.create do |object|
          object.name = attrs[:name]
          object.title = attrs[:brand]
          object.content = attrs[:link]
        end
      end
    end

    def add_product_prices(product, price, us_price = nil)
      product.price = price
      #us_price ||= price
      #product.us_price = us_price

      product.save
    end
  end
end
