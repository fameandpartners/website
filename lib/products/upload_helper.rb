
module Products
  module UploadHelper

    def create_or_update_products(product_json)
      #info "Creating or Update Products"
      upload = JSON.parse(product_json, :symbolize_names => true) 
      upload.map do |prod|
        begin

          product = create_or_update_product(prod)

          # Not quite - Spree::OptionType.size.option_values.collect(&:name)
          sizes = %w(
            US0/AU4   US2/AU6   US4/AU8   US6/AU10  US8/AU12  US10/AU14
            US12/AU16 US14/AU18 US16/AU20 US18/AU22 US20/AU24 US22/AU26
          )

          details = prod[:details]

          add_product_properties(product, details)

          add_product_color_options(product, details[:colors])

          add_product_variants(product, sizes, details[:colors] || [], details[:price_aud].to_f, details[:price_usd].to_f)

          add_product_customizations(product, prod[:customization_list] || [])

          #update_or_create_base_visualization(details[:colors])

          update_or_add_customization_visualizations(product, prod[:customization_visualization_list], details[:silhouette], details[:neckline])
          add_product_height_ranges( product )

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

    def create_or_update_product(prod)
      sku = prod[:style_number].to_s.downcase.strip

      raise 'SKU should be present!' unless sku.present?

      master = Spree::Variant.where(deleted_at: nil, is_master: true).where('LOWER(TRIM(sku)) = ?', sku).order('id DESC').first

      product = master.try(:product)

      if product.blank?

        product = Spree::Product.new(sku: sku, featured: false, on_demand: true, available_on: @available_on)
      end


      taxon_ids = prod[:details][:taxons]&.map { |x| Spree::Taxon.find_by_name(x)&.id }

      attributes = {
        name: prod[:details][:name],
        price: prod[:details][:price_aud].to_f,
        description: prod[:details][:description],
        taxon_ids: taxon_ids,
        available_on: @available_on || product.available_on #NEED TO ADD THIS TO JSON
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
      prdmo = ProductMakingOption.new(  { product_id: product.id,
                                        active: true,
                                        option_type: 'slow_making',
                                        price: -0.1,
                                        currency: 'USD' },
                                        without_protection: true
                                      )
      # only connect the 2 if not already done before
      if prdmo.save
        product.making_options << prdmo
      end

      new_product = product.persisted? ? 'Updated' : 'Created'

      product.save!

      #trying without this

      if prod[:details][:price_aud].present? || prod[:details][:price_usd].present?
         add_product_prices(product, prod[:details][:price_aud].to_f, prod[:details][:price_usd].to_f)
       end
     # info "#{section_heading} #{new_product} id=#{product.id}"
      product
    end

    def add_product_color_options(product, available_colors)
      #debug "#{get_section_heading(sku: product.sku, name: product.name)} #{__method__}"
      color_ids = []
      available_colors.map do |available_color|
        color = Spree::OptionValue.find_by_presentation(available_color)
        color_ids << color.id
        #TODO: Do we want a check here to see if the color exists? What do we do when it doesnt exist
        product.product_color_values.where(option_value_id: color.id, custom: false).first_or_create
      end

      product.product_color_values.where(custom: false).where('option_value_id NOT IN (?)', color_ids).destroy_all
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
          # variant.send :write_attribute, :on_demand, true. #TODO: Address this shit why do i need it? Cant I just wrap the save in the same unless?

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

    def add_product_customizations(product, custs)
      customizations = []

      custs.each do |customization|
        new_customization = {
                              id: customization[:customization_id], 
                              name: customization[:customization_presentation].downcase.gsub(' ', '-'), 
                              price: customization[:price], #TODO: add this to the json being sent
                              presentation: customization[:customization_presentation],
                              required_by: customization[:required_by]
                            }
        customizations << { customisation_value: new_customization }
      end
      product.customizations = customizations.to_json
      product.save

      product.customizations
    end

    def update_or_add_customization_visualizations(product, customization_list, default_silhouette, default_neckline)
      customization_list.each do |cust|
        id = cust[:customization_ids].sort.join('_')
        silhouette = cust[:silhouette].blank? ? default_silhouette : cust[:silhouette]
        neckline = cust[:neckline].blank? ? default_neckline : cust[:neckline]
        cust[:lengths].each do |length|         
          cv = CustomizationVisualization.where(customization_ids: id, product_id: product.id, length: length[:name], silhouette: silhouette, neckline: neckline)
                                         .first_or_create(customization_ids: id, product_id: product.id, length: length[:name], silhouette: silhouette, neckline:neckline)
        
          cv.render_urls = length[:render_urls].to_json
          cv.incompatible_ids = length[:incompatability_list].join(',') #never manipulated so just put it in as ta string and split on return
          cv.save!
        end
      end
    end

    def add_product_height_ranges( product )
      master_variant = product.master

      master_variant.style_to_product_height_range_groups = []
      
      product_height_groups = ProductHeightRangeGroup.default_six

      product_height_groups.each { |phg| master_variant.style_to_product_height_range_groups << StyleToProductHeightRangeGroup.new( product_height_range_group: phg ) }

      master_variant.save
    end

    def update_or_create_base_visualization(product, product_details)

    end

  end
end