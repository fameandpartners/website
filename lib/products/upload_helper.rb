
module Products
  module UploadHelper

    def create_or_update_products(product_json)
      #info "Creating or Update Products"
      upload = JSON.parse(product_json, :symbolize_names => true) 
      upload.map do |prod|
        begin
          details = prod[:details]

          # Not quite - Spree::OptionType.size.option_values.collect(&:name)
          if (details[:type] === "swatch")
            sizes = %w(US0/AU4)
            category = Category.where(category: 'Sample').first_or_create( { category: "Sample", subcategory: "Fabric" })
            taxon = nil
            on_demand = false
            # taxon = taxon = Spree::Taxon.find_by_permalink('6-10-week-delivery');
          else
            sizes = %w(
              US0/AU4   US2/AU6   US4/AU8   US6/AU10  US8/AU12  US10/AU14
              US12/AU16 US14/AU18 US16/AU20 US18/AU22 US20/AU24 US22/AU26
            )
            category = nil
            taxon = Spree::Taxon.find_by_permalink('6-10-week-delivery');
            on_demand = true
          end

          product = create_or_update_product(prod, category, on_demand, taxon)



          #color_map = details[:colors].map{ |x| { color: x } }
          add_product_properties(product, details)
          fabric_products = add_product_color_options(product, details[:fabrics], details[:colors]) 

          add_product_variants(product, sizes, fabric_products, 0.0, 0.0) 
          add_product_customizations(product, prod[:customization_list] || [], nil)
          add_product_height_ranges( product )

          product.hidden = true #MIGHT MOVE THIS
          product.available_on = product.created_at

          product.save!

          product
        end
      end.compact
    end

    def add_product_prices(product, price, us_price = nil)
      product.price = price
      product.save

      master_variant = product.master

      usd = Spree::Price.find_or_create_by_variant_id_and_currency(master_variant.id, 'USD')
      usd.amount = us_price if us_price.present?
      usd.save!
    end

    def create_or_update_product(prod, category, on_demand, taxon)
      sku = prod[:style_number].to_s.downcase.strip

      raise 'SKU should be present!' unless sku.present?

      master = Spree::Variant.where(deleted_at: nil, is_master: true).where('LOWER(TRIM(sku)) = ?', sku).order('id DESC').first

      product = master.try(:product)

      if product.blank?
        product = Spree::Product.new(sku: sku, featured: false, on_demand: on_demand, available_on: @available_on)
      end

      ActiveRecord::Associations::Preloader.new(product, variants: [:option_values, :prices]).run

      taxon_ids = prod[:details][:taxons]&.map { |x| Spree::Taxon.find_by_name(x)&.id }
      taxon_ids << taxon.id if taxon

      attributes = {
        name: prod[:details][:name],
        price: 0.0.to_f,
        description: prod[:details][:description],
        taxon_ids: taxon_ids,
        available_on: @available_on || product.available_on, #NEED TO ADD THIS TO JSON
        category: category
      }

      edits = Spree::Taxonomy.find_by_name('Edits') || Spree::Taxonomy.find_by_id(8)
      if product.persisted?
        attributes[:taxon_ids] += product.taxons.where(taxonomy_id: edits.try(:id)).map(&:id) #WTF does this do
      end

      #attributes.select!{ |name, value| value.present? }  remove this see what happens

      product.assign_attributes(attributes, without_protection: true)

      if attributes[:name].present?
        if product.persisted?
          if product.valid? && product.name_was.downcase != attributes[:name].downcase  #Think i can get rid of this
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

      #trying without this

     #if min_length[:price_aud].present? || min_length[:price_usd].present?
        add_product_prices(product, 0.0, 0.0)
       #end
     # info "#{section_heading} #{new_product} id=#{product.id}"
      product
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
          fab.price_aud = color[:price_aud].to_f + fabric[:price_aud].to_f
          fab.price_usd = color[:price_usd].to_f + fabric[:price_usd].to_f
          fab.material = fabric[:presentation]
          fab.option_fabric_color_value = fabric_color_option
          fab.option_value = color
          fab.save!


          fabric_product = FabricsProduct.find_or_create_by_fabric_id_and_product_id(fab.id, product.id)
          fabric_product.recommended = true
          fabric_product.save!

          color_ids << color.id
          #TODO: Do we want a check here to see if the color exists? What do we do when it doesnt exist
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

    def add_product_variants(product, sizes, fabrics_products, price_in_aud, price_in_usd)  
      variants = []
      size_option = Spree::OptionType.size
      color_option = Spree::OptionType.color

      product.option_types = [size_option, color_option]
      product.save

      product.reload

      sizes.each do |size_name|
        size_value  = size_option.option_values.where(name: size_name).first
        product.variants
        size_variants = product.variants.select { |variant| variant.option_value_ids.include?(size_value.id)}

        fabrics_products.each do |fabrics_product|
          fabric_color = fabrics_product.fabric.option_fabric_color_value

          next if size_value.blank? || fabric_color.blank?

          variant = size_variants.detect {|variant| variant.option_value_ids.include?(fabric_color.id) }
          unless variant.present?
            variant = product.variants.build
            variant.option_values = [size_value, fabric_color]
          end

          # Avoids errors with Spree hooks updating lots and lots of orders.
          # See: spree/core/app/models/spree/variant.rb:146 #on_demand=
          variant.send :write_attribute, :on_demand, true
          Spree::Variant.skip_callback( :save, :after, :recalculate_product_on_hand )
          Spree::Variant.skip_callback( :save, :after, :process_backorders )
          Spree::Variant.skip_callback( :save, :after, :update_index_on_save )

          variant.save!

          aud = variant.prices.where(currency: "AUD").first_or_create
          aud.amount = price_in_aud
          aud.save!

          usd = variant.prices.where(currency: "USD").first_or_create
          usd.amount = price_in_usd
          usd.save!

          variants.push(variant) if variant.persisted?
        end
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