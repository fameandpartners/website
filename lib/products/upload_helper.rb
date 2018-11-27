
module Products
  module UploadHelper

    def create_or_update_products(product_json)
      #info "Creating or Update Products"
      upload = JSON.parse(product_json, :symbolize_names => true) 
      upload.map do |prod|
        begin
          details = prod[:details]
          price_in_aud = details[:price_aud]
          price_in_usd = details[:price_usd]


          # Not quite - Spree::OptionType.size.option_values.collect(&:name)
          if (details[:type] === "swatch")
            sizes = %w(US0/AU4)
            category = Category.where(category: 'Sample').first_or_create( { category: "Sample", subcategory: "Fabric" })
            taxon = nil
            on_demand = false
          else
            sizes = %w(
              US0/AU4   US2/AU6   US4/AU8   US6/AU10  US8/AU12  US10/AU14
              US12/AU16 US14/AU18 US16/AU20 US18/AU22 US20/AU24 US22/AU26
            )
            category = nil
            on_demand = true
          end



          product = create_or_update_product(prod, category, on_demand)

          #color_map = details[:colors].map{ |x| { color: x } }
          # add_product_properties(product, details)
          add_product_prices(product, price_in_aud, price_in_usd)
          add_product_color_options(product, details[:fabrics], details[:colors]) 
          add_product_variants(product, sizes, price_in_aud, price_in_usd) 
          add_product_customizations(product, prod[:customization_list] || [], nil)
          add_product_height_ranges( product )
          add_making_options(product, prod[:making_options])
          add_curations(product, prod[:curations])

          product.save!

          product
        end
      end.compact
    end

    def add_curations(product, curations)
      Curation.where(product_id: product.id).update_all(active: false)

      curations.each do |c|
        curation = product.curations.find {|x| x.pid == c[:pid] } || Curation.new(product_id: product.id, pid: c[:pid])
        curation.active = true
        curation.name = c[:name]
        curation.taxons = c[:taxons].map {|t| Spree::Taxon.find_by_name(t)}
        curation.save!
      end
    end

    def add_product_prices(product, price_in_aud, price_in_usd)
      master_variant = product.master

      aud = master_variant.prices.where(currency: "AUD").first_or_create
      aud.amount = price_in_aud
      aud.save!

      usd = master_variant.prices.where(currency: "USD").first_or_create
      usd.amount = price_in_usd
      usd.save!
    end

    def create_or_update_product(prod, category, on_demand)
      sku = prod[:style_number].to_s.strip

      raise 'SKU should be present!' unless sku.present?

      master = Spree::Variant.where(deleted_at: nil, is_master: true).where('sku = ?', sku).order('id DESC').first

      product = master.try(:product)

      if product.blank?
        product = Spree::Product.new(sku: sku, featured: false, on_demand: on_demand, available_on: @available_on)
      end

      ActiveRecord::Associations::Preloader.new(product, variants: [:option_values, :prices]).run

      taxon_ids = prod[:details][:taxons]&.map { |x| Spree::Taxon.find_by_name(x)&.id }

      attributes = {
        name: prod[:details][:name],
        price: 0.0.to_f,
        description: prod[:details][:description],
        taxon_ids: taxon_ids,
        available_on: @available_on || product.available_on, #NEED TO ADD THIS TO JSON
        category: category,
        permalink: prod[:details][:name].downcase.gsub(/\s/, '_')
      }

      product.assign_attributes(attributes, without_protection: true)

      product.hidden = !prod[:details][:active]
      product.available_on = product.created_at

      product.save!

      product
    end


    def add_making_options(product, making_options)
      product.making_options.each do |pmo|
        pmo.active = false;
        pmo.save!
      end

      making_options.each do |pmo|
        mo = MakingOption.find_by_code(pmo[:code])
        pmo = product.making_options.find {|x| x.making_option_id == mo.id } || ProductMakingOption.new(product_id: product.id, making_option_id: mo.id)
        pmo.active = true
        pmo.save!
      end
    end

    def add_product_color_options(product, fabrics, colors)
      #debug "#{get_section_heading(sku: product.sku, name: product.name)} #{__method__}"
      color_ids = []
      fabrics.each do |fabric|
        colors.each do |color|
          fabric_code = "#{fabric[:code]}-#{color[:code]}"
          fabric_presentation = "#{color[:presentation]} #{fabric[:presentation]}";

          fabric_color_option = find_or_create_fabric_color_option(fabric_code, fabric_presentation, color[:hex])
          color = find_or_create_color_option(color[:code], color[:presentation], color[:hex])

          fab = Fabric.find_or_create_by_name(fabric_code)
          fab.presentation = fabric_presentation
          fab.production_code = fabric[:code]
          fab.material = fabric[:presentation]
          fab.option_fabric_color_value = fabric_color_option
          fab.option_value = color
          fab.save!


          fabric_product = FabricsProduct.find_or_create_by_fabric_id_and_product_id(fab.id, product.id)
          fabric_product.recommended = true
          fabric_product.price_aud = color[:price_aud].to_f + fabric[:price_aud].to_f
          fabric_product.price_aud = color[:price_usd].to_f + fabric[:price_usd].to_f
          fabric_product.save!

          color_ids << color.id
          product.product_color_values.where(option_value_id: color.id, custom: false).first_or_create
        end
      end

      product.product_color_values.where(custom: false).where('option_value_id NOT IN (?)', color_ids).destroy_all

      product.fabric_products
    end

    private def find_or_create_fabric_color_option(name, presentation, hex)
      fabric_color = Spree::OptionType.fabric_color.option_values.find_or_create_by_name(name)
      fabric_color.presentation = presentation
      fabric_color.value = hex;
      fabric_color.save!
      
      fabric_color
    end

    private def find_or_create_color_option(name, presentation, hex)
      color = Spree::OptionType.color.option_values.find_or_create_by_name(name)
      color.presentation = presentation
      color.value = hex;
      color.save!
      
      color
    end

    def add_product_properties(product, details)
      #debug "#{get_section_heading(sku: product.sku, name: product.name)} #{__method__}"
      allowed = ['style_notes',
                 'fit',
                 'fabric',
                 'factory_name'
                 ]

      
      allowed.each {|property_name| product.set_property(property_name, details[property_name])}

      product.set_property('care_instructions',"Professional dry-clean only.\nSee label for further details.") #always this value
      
      if factory = Factory.find_by_name(details[:factory_name].try(:capitalize))
        product.factory = factory
      end

      product
    end

    def add_product_variants(product, sizes, price_in_aud, price_in_usd)  
      variants = []
      size_option = Spree::OptionType.size
      #color_option = Spree::OptionType.color

      product.option_types = [size_option]
      product.save

      product.reload

      sizes.each do |size_name|
        size_value  = size_option.option_values.where(name: size_name).first
        variant = product.variants.first { |variant| variant.option_value_ids.include?(size_value.id)}

        unless variant.present?
          variant = product.variants.build
          variant.option_values = [size_value]
        end

        # Avoids errors with Spree hooks updating lots and lots of orders.
        # See: spree/core/app/models/spree/variant.rb:146 #on_demand=
        variant.send :write_attribute, :on_demand, true
        Spree::Variant.skip_callback( :save, :after, :recalculate_product_on_hand )
        Spree::Variant.skip_callback( :save, :after, :process_backorders )

        variant.save!

        aud = variant.prices.where(currency: "AUD").first_or_create
        aud.amount = price_in_aud
        aud.save!

        usd = variant.prices.where(currency: "USD").first_or_create
        usd.amount = price_in_usd
        usd.save!

        variants.push(variant)
      end

      product.variants.where('id NOT IN (?)', variants.map(&:id)).update_all(deleted_at: Time.now)
    end

    def add_product_customizations(product, custs, lengths)
      customizations = []

      custs.reject{|x| x[:type]&.downcase == 'size' ||  x[:type]&.downcase == 'fabric'}.each do |customization|
        new_customization = {
                              id: customization[:code].downcase, 
                              name: customization[:code], 
                              price: customization[:price_usd],
                              price_aud: customization[:price_aud],#TODO: add this to the json being sent
                              presentation: customization[:presentation],
                              manifacturing_sort_order: customization[:manifacturing_sort_order]
                            }
        customizations << { customisation_value: new_customization }
      end
      #product.lengths = { available_lengths: lengths }.to_json # Dont think I need this anymore
      product.customizations = customizations.to_json
      product.save

      product.customizations
    end

    def add_product_height_ranges( product )
      master_variant = product.master

      master_variant.style_to_product_height_range_groups = []
      
      product_height_groups = ProductHeightRangeGroup.default_six

      product_height_groups.each { |phg| master_variant.style_to_product_height_range_groups << StyleToProductHeightRangeGroup.new( product_height_range_group: phg ) }

      master_variant.save
    end
  end
end