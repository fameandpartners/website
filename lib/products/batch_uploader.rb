# encoding: utf-8

require 'roo'
require 'ostruct'

module Products
  class BatchUploader
    attr_reader :parsed_data

    include ActionView::Helpers::TextHelper # for truncate

    def initialize(available_on)
      @@titles_row_numbers = [8, 10, 11, 12]
      @@first_content_row_number = 13
      @available_on = available_on
    end

    def parse_file(file_path)
      @parsed_data = []
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

      columns = get_columns_codes(book)

      rows = get_rows_indexes(book, columns)

      book.default_sheet = book.sheets.first

      # rows = [rows.first] if Rails.env.development?
      rows.to_a.each do |row_num|
        raw = {}

        # Basic
        raw[:sku]                 = book.cell(row_num, columns[:sku])
        raw[:name]                = book.cell(row_num, columns[:name])
        raw[:description]         = book.cell(row_num, columns[:description])
        raw[:price_in_aud]        = book.cell(row_num, columns[:price_in_aud])
        raw[:price_in_usd]        = book.cell(row_num, columns[:price_in_usd])
        raw[:taxons]              = Array.wrap(columns[:taxons]).map{|i| book.cell(row_num, i) }.reject(&:blank?)
        raw[:colors]              = Array.wrap(columns[:colors]).map{|i| book.cell(row_num, i) }.reject(&:blank?)
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
        raw[:color_customization] = book.cell(row_num, columns[:color_customization])
        raw[:short_description]   = book.cell(row_num, columns[:short_description])

        # Additional
        raw[:song_link]           = book.cell(row_num, columns[:song_link])
        raw[:song_name]           = book.cell(row_num, columns[:song_name])

        raw[:customizations]      = []
        columns[:customizations].each_with_index do |customization, index|
          raw[:customizations] << {
            name: book.cell(row_num, customization[:name]).to_s.gsub("_x000D_", '').strip,
            price: book.cell(row_num, customization[:price]).to_s.gsub(/[^\d\.]/, '').to_f,
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

          if taxon.blank?
            taxon = range.children.create do |object|
              object.name = taxon_name
              object.taxonomy = range.taxonomy
            end
          end

          processed[:taxon_ids] << taxon.id
        end

        color_option = Spree::OptionType.color


        processed[:colors] = []
        raw[:colors].each do |presentation|
          presentation = presentation.strip

          color = color_option.option_values.where('LOWER(presentation) = ?', presentation.downcase).first

          if color.blank?
            color = color_option.option_values.create do |object|
              object.name = presentation.downcase.gsub(' ', '-')
              object.presentation = presentation
            end
          end

          processed[:colors] << color.name
        end

        processed[:customizations] = []
        raw[:customizations].each do |customization|
          if customization[:name].present?
            processed[:customizations] << customization
          end
        end


        item = {
          # Basic
          sku:                  processed[:sku] || raw[:sku],
          name:                 processed[:name] || raw[:name],
          price_in_aud:         raw[:price_in_aud],
          price_in_usd:         raw[:price_in_usd],
          description:          processed[:description] || raw[:description],
          colors:               processed[:colors],
          taxon_ids:            processed[:taxon_ids],
          style_profile: {
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
            petite:               raw[:petite]
          },
          properties: {
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
            product_details:      processed[:product_details],
            revenue:              raw[:revenue],
            cogs:                 raw[:cogs],
            video_id:             processed[:video_id],
            color_customization:  raw[:color_customization],
            short_description:    raw[:short_description]
          },
          song: {
            link:            raw[:song_link],
            name:            raw[:song_name],
          },
          customizations:       processed[:customizations],
        }

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
        color_customization: /colour customisation/i,
        #product_coding: /product coding/i,
        shipping: /shipping/i,
        stylist_quote_short: /stylist inspiration quote/i,
        #stylist_quote_long: /expanded stylist quote/i,
        product_details: /product details/i,
        short_description: /short description/i
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

      @codes[:price_in_aud] = 4
      @codes[:price_in_usd] = 5
      @codes[:description] = 6

      @codes[:customizations] = []
      book.row(@@titles_row_numbers.second).each_with_index do |title, index|
        next unless title =~ /customisation \#\d/i
          @codes[:customizations] << {
            name: index + 1, #honestly wtf
            price: index + 2
          }
      end

      book.row(@@titles_row_numbers.second).each_with_index do |title, index|
        next unless title =~ /Music Track Link/i
        @codes[:song_link]      = index + 1
        @codes[:song_name]      = index + 2
      end


      @codes[:revenue]        = 135
      @codes[:cogs]           = 136
      @codes[:product_coding] = 137
      @codes[:video_id]       = 139 # 138 139 with
      @codes[:short_description] = 140

      @codes
    end

    def get_rows_indexes(book, columns)
      first_empty_row_num = @@first_content_row_number

      total_rows = book.last_row(book.sheets.first)
      while first_empty_row_num < total_rows and book.cell(first_empty_row_num, columns[:sku]).present?
        first_empty_row_num += 1
      end

      (@@first_content_row_number..first_empty_row_num)
    end

    # create product with restored data
    def create_or_update_products(products_attrs)
      products_attrs.map do |attrs|
        args = attrs.symbolize_keys

        begin
          product = create_or_update_product(args.merge!(
            sizes: %W{0 2 4 6 8 10 12 14 16 18 20 22 24 26}
          ))

          add_product_properties(product, args[:properties].symbolize_keys)
          add_product_variants(product, args[:sizes], args[:colors] || [], args[:price_in_aud], args[:price_in_usd])
          add_product_style_profile(product, args[:style_profile].symbolize_keys)
          add_product_customizations(product, args[:customizations] || [])
          add_product_song(product, args[:song].symbolize_keys || {})

          product
        rescue Exception => message
          Rails.logger.warn(message)
          puts "======== Exception ========"
          puts args[:sku]
          puts args[:style_name]
          puts message
          puts "==========================="
          nil
        end
      end.compact
    end

    private

    def create_or_update_product(args)
      sku = args[:sku].to_s.downcase.strip

      raise 'SKU should be present!' unless sku.present?

      master = Spree::Variant.where(deleted_at: nil, is_master: true).where('LOWER(TRIM(sku)) = ?', sku).order('id DESC').first

      product = master.try(:product)

      if product.blank?
        product = Spree::Product.new(sku: sku, featured: false, on_demand: true, available_on: @available_on)
      end

      attributes = {
        name: args[:name],
        price: args[:price_in_aud],
        description: args[:description],
        taxon_ids: args[:taxon_ids] || [],
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

      new_product = product.persisted? ? 'Updated' : 'New'

      product.save!
      puts "Saving: #{new_product} - #{product.sku} - #{product.id} - #{product.name}"

      if args[:price_in_aud].present? || args[:price_in_usd].present?
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
                 :cogs,
                 :video_id,
                 :color_customization,
                 :short_description]

      properties = args.slice(*allowed).select{ |name, value| value.present? }

      properties.each do |name, value|
        product.set_property(name, value)
      end

      if factory = Factory.find_by_name(args[:factory_name].capitalize)
        product.factory = factory
      end

      product
    end

    def add_product_variants(product, sizes, colors, price_in_aud, price_in_usd)
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

          aud = Spree::Price.find_or_create_by_variant_id_and_currency(variant.id, 'AUD')
          aud.amount = price_in_aud
          aud.save!

          usd = Spree::Price.find_or_create_by_variant_id_and_currency(variant.id, 'USD')
          usd.amount = price_in_usd
          usd.save!

          variants.push(variant) if variant.persisted?
        end
      end

      variants

      product.variants.where('id NOT IN (?)', variants.map(&:id)).update_all(deleted_at: Time.now)
    end

    def add_product_customizations(product, array_of_attributes)
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
      if raw_attrs[:link].present?
        song = product.moodboard_items.song.first || product.moodboard_items.song.build

        song.update_attributes(content: raw_attrs[:link], name: raw_attrs[:name])
      end
    end

    def add_product_prices(product, price, us_price = nil)
      product.price = price
      product.save

      master_variant = product.master

      usd = Spree::Price.find_or_create_by_variant_id_and_currency(master_variant.id, 'USD')
      usd.amount = us_price
      usd.save!
    end
  end
end
