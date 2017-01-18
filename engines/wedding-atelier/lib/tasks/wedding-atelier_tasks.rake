namespace :wedding_atelier do
  task populate_products: :environment do
    taxonomy = Spree::Taxonomy.find_or_create_by_name('Wedding Atelier')
    taxon = taxonomy.taxons.find_or_create_by_name('Base Silhouette')

    sizes = Spree::OptionType.where(name: 'dress-size').first

    colour_attrs = [
      { presentation: 'Champagne', name: 'champagne' },
      { presentation: 'Navy', name: 'navy' },
      { presentation: 'Black', name: 'black' },
      { presentation: 'Berry', name: 'berry' },
      { presentation: 'Burgundy', name: 'burgundy' },
      { presentation: 'Red', name: 'red' },
      { presentation: 'Watermelon', name: 'watermelon' },
      { presentation: 'Coral', name: 'coral' },
      { presentation: 'Peach', name: 'peach' },
      { presentation: 'Bright Blush', name: 'bright-blush' },
      { presentation: 'Pale Pink', name: 'pale-pink' },
      { presentation: 'Lavender', name: 'lavender' },
      { presentation: 'Plum', name: 'plum' },
      { presentation: 'Royal Blue', name: 'royal-blue' },
      { presentation: 'Cobalt Blue', name: 'cobalt-blue'},
      { presentation: 'Pale Blue', name: 'pale-blue'},
      { presentation: 'Aqua', name: 'aqua'},
      { presentation: 'Bright Turquoise', name: 'bright-turquoise'},
      { presentation: 'Mint', name: 'mint'},
      { presentation: 'Pale Grey', name: 'pale-grey'},
    ]

    colours = find_or_create_option_type('wedding-atelier-colors', 'Colour', colour_attrs)

    fabric_attrs = [
      { presentation: 'Heavy Georgette', name: 'HG' },
      { presentation: 'Matte Satin', name: 'MS' },
    ]

    # Common option types
    fabrics = find_or_create_option_type('wedding-atelier-fabrics',
                                         'Fabric',fabric_attrs)

    length_attrs = [
      { presentation: 'Mini', name: 'MN'},
      { presentation: 'Knee', name: 'KN'},
      { presentation: 'Petti', name: 'PT'},
      { presentation: 'Midi', name: 'MD'},
      { presentation: 'Ankle', name: 'AK'},
      { presentation: 'Maxi', name: 'MX'}
    ]
    lengths = find_or_create_option_type('wedding-atelier-lengths',
                                         'Length', length_attrs)

    base_option_types = [sizes, fabrics, lengths, colours]

    # Strapless ----------------------------------------------------------------------------------
    strapless_styles = [
      { presentation: 'Add sheer draped panel to bodice', price: 14.99 },
      { presentation: 'Add wide off shoulder panel', price: 19.99 },
      { presentation: 'Add separate cape', price: 24.99 },
      { presentation: 'Add separate wide tie belt', price: 19.99 },
      { presentation: 'Add wide draped arm bow ties', price: 14.99 }
    ]

    strapless_fits = [
      { presentation: 'Add wide bow tie straps', price: 9.99 },
      { presentation: 'Change to curved neckline', price: 9.99 },
      { presentation: 'Add flared hem ruffle', price: 24.99 },
      { presentation: 'Add narrow adjusatble straps', price: 9.99 },
      { presentation: 'Change to Hi-low hem', price: 29.99 }
    ]

    # TODO: Ask for the base price
    strapless_attrs = {
      name: 'Strapless Column Dress',
      sku: 'FP2212',
      price: 200,
      hidden: true
    }

    find_or_create_product(strapless_attrs, strapless_styles,
                          strapless_fits, taxon, base_option_types, {colours: colours, sizes: sizes})

    # Fit and Flare  -----------------------------------------------------------------------------
    fit_and_flare_styles = [
      { presentation: 'Add 2-layer ruffle cape (attached)', price: 24.99 },
      { presentation: 'Add single sleeve with cuff', price: 14.99 },
      { presentation: 'Add bow to shoulder', price: 9.99 },
      { presentation: 'Add flared arm bands', price: 19.99 },
      { presentation: 'Add separate wide tie belt', price: 19.99 }
    ]

    fit_and_flare_fits = [
      { presentation: 'Change to spaghetti straps', price: 9.99 },
      { presentation: 'Change to halter neckline', price: 9.99 },
      { presentation: 'Change to strapless neckline', price: 9.99 },
      { presentation: 'Change to scoop neck', price: 9.99 },
      { presentation: 'Change to hi-low hem', price: 9.99 }
    ]

    fit_and_flare_attrs = {
      name: 'Fit and flare dress',
      sku: 'FP2213',
      price: 200,
      hidden: true
    }

    find_or_create_product(fit_and_flare_attrs, fit_and_flare_styles,
                          fit_and_flare_fits, taxon, base_option_types, {colours: colours, sizes: sizes})

    # Shift --------------------------------------------------------------------------------------
    shift_styles = [
      { presentation: 'Add long fitted sleeves with shoulder cut-outs', price: 19.99 },
      { presentation: 'Add draped side arm panels (attached to side seam)', price: 19.99 },
      { presentation: 'Add wide off shoulder panel', price: 19.99 },
      { presentation: 'Add long flared sleeve', price: 19.99 },
      { presentation: 'Add separate wide tie belt', price: 19.99 }
    ]

    shift_fits = [
      { presentation: 'Change to plunging v-back neckline', price: 9.99 },
      { presentation: 'Change to plunging v-front neckline', price: 9.99 },
      { presentation: 'Change to one shoulder neckline', price: 9.99 },
      { presentation: 'Change to classic neckline', price: 9.99 },
      { presentation: 'Change to a-line silhouette', price: 14.99 }
    ]

    # TODO: Ask for the base price
    shift_attrs = {
      name: 'Shift dress',
      sku: 'FP2214',
      price: 200,
      hidden: true
    }

    find_or_create_product(shift_attrs, shift_styles,
                          shift_fits, taxon, base_option_types, {colours: colours, sizes: sizes})

    # Slip ---------------------------------------------------------------------------------------
    slip_styles = [
      { presentation: 'Add hem ruffle', price: 24.99 },
      { presentation: 'Add cape (longer with arm splits)', price: 29.99 },
      { presentation: 'Add long flared sleeve', price: 19.99 },
      { presentation: 'Add separate wide tie belt', price: 19.99 },
      { presentation: 'Add wide draped arm bow ties', price: 14.99 }
    ]

    slip_fits = [
      { presentation: 'Change to multi back straps', price: 14.99 },
      { presentation: 'Change to rouleau straps', price: 9.99 },
      { presentation: 'Change to round back neckline', price: 9.99 },
      { presentation: 'Change to v-front neckline', price: 9.99 },
      { presentation: 'Add side split', price: 9.99 }
    ]

    # TODO: Ask for the base price
    slip_attrs = {
      name: 'Slip dress',
      sku: 'FP2215',
      price: 200,
      hidden: true
    }

    find_or_create_product(slip_attrs, slip_styles,
                          slip_fits, taxon, base_option_types, {colours: colours, sizes: sizes})

    # Wrap ---------------------------------------------------------------------------------------
    wrap_styles = [
      { presentation: 'Add separate wide tie belt', price: 19.99 },
      { presentation: 'Add cape (longer with arm splits)', price: 29.99 },
      { presentation: 'Add long flared sleeve', price: 19.99 },
      { presentation: 'Add wide arm ties', price: 14.99 },
      { presentation: 'Add voluminous half sleeve', price: 19.99 }
    ]

    wrap_fits = [
      { presentation: 'Change to rouleau straps', price: 9.99 },
      { presentation: 'Add hem ruffle', price: 24.99 },
      { presentation: 'Change to v-wrap back neckline', price: 14.99 },
      { presentation: 'Change to a-line skirt silhouette', price: 14.99 },
      { presentation: 'Add double hem ruffle', price: 29.99 }
    ]

    # TODO: Ask for the base price
    wrap_attrs = {
      name: 'Wrap dress',
      sku: 'FP2216',
      price: 200,
      hidden: true
    }

    find_or_create_product(wrap_attrs, wrap_styles,
                          wrap_fits, taxon, base_option_types, {colours: colours, sizes: sizes})

    # Tri-cup ------------------------------------------------------------------------------------
    tri_cup_styles = [
      { presentation: 'Add separate cape', price: 24.99 },
      { presentation: 'Change to tie straps (remove ring & slide)', price: 9.99 },
      { presentation: 'Add ruffles to cups', price: 14.99 },
      { presentation: 'Add ruffles to steams', price: 24.99 },
      { presentation: 'Add detachable bow', price: 19.99 }
    ]

    tri_cup_fits = [
      { presentation: 'Change to column skirt', price: 14.99 },
      { presentation: 'Change to wide straps', price: 9.99 },
      { presentation: 'Change cross back straps with bow', price: 9.99 },
      { presentation: 'Change to babydoll silhouette', price: 14.99 },
      { presentation: 'Add double hem ruffle', price: 29.99 }
    ]

    # TODO: Ask for the base price
    tri_cup_attrs = {
      name: 'Tri-cup dress',
      sku: 'FP2220',
      price: 200,
      hidden: true
    }

    find_or_create_product(tri_cup_attrs, tri_cup_styles,
                          tri_cup_fits, taxon, base_option_types, {colours: colours, sizes: sizes})

    # Two piece ----------------------------------------------------------------------------------
    two_piece_styles = [
      { presentation: 'Add ruffle to bodice edge', price: 14.99 },
      { presentation: 'Add back neck bow tie', price: 14.99 },
      { presentation: 'Add side ties (bow at back)', price: 19.99 },
      { presentation: 'Add wide drapped arm bow ties', price: 14.99 },
      { presentation: 'Add draped cold shoulder sleeve', price: 19.99 }
    ]

    two_piece_fits = [
      { presentation: 'Add hem ruffle', price: 24.99 },
      { presentation: 'Change to strapless bodice', price: 14.99 },
      { presentation: 'ADd front keyhole', price: 9.99 },
      { presentation: 'Change to column skirt', price: 14.99 },
      { presentation: 'Change to classic bodice with short sleeve', price: 19.99 }
    ]

    # TODO: Ask for the base price
    two_piece_attrs = {
      name: 'Two piece dress',
      sku: 'FP2218',
      price: 200,
      hidden: true
    }

    find_or_create_product(two_piece_attrs, two_piece_styles,
                          two_piece_fits, taxon, base_option_types, {colours: colours, sizes: sizes})

    # Multi way ----------------------------------------------------------------------------------
    multi_way_styles = [
      { presentation: 'Add ruffle down skirt edge', price: 14.99 },
      { presentation: 'Add rufle at front neckline', price: 14.99 },
      { presentation: 'Add separete arm bands', price: 14.99 },
      { presentation: 'Add gathered hem ruffle', price: 24.99 },
      { presentation: 'Add small train', price: 14.99 }
    ]

    multi_way_fits = [
      { presentation: 'Change to full volume skirt', price: 24.99 },
      { presentation: 'Remove overlapping skirt panel (split)', price: 9.99 },
      { presentation: 'Change to hi-low hem', price: 24.99 },
      { presentation: 'Raise front and back neckline (with added under bodice)', price: 14.99 },
      { presentation: 'Change to column skirt', price: 14.99 }
    ]

    # TODO: Ask for the base price
    multi_way_attrs = {
      name: 'Multi way dress',
      sku: 'FP2219',
      price: 200,
      hidden: true
    }

    find_or_create_product(multi_way_attrs, multi_way_styles,
                          multi_way_fits, taxon, base_option_types, {colours: colours, sizes: sizes})
  end

  def find_or_create_option_type(name, presentation, option_values)
    option_type = Spree::OptionType.find_or_create_by_name(name) do |ot|
      ot.presentation = presentation
    end
    option_values.each do |attrs|
      ov = Spree::OptionValue.find_or_create_by_name(attrs[:name]) do |o|
        o.presentation = attrs[:presentation]
      end
      option_type.option_values << ov unless option_type.option_values.include? ov
    end
    option_type
  end

  def create_customizations(product, customizations, customization_type)
    initial = customization_type[0].upcase
    customizations.each_with_index do |c, index|
      product.customisation_values.create(name: "#{initial}#{index + 1}",
                                          presentation: c[:presentation],
                                          customisation_type: customization_type,
                                          price: c[:price]
                                          )
    end
  end

  def find_or_create_product(attrs, styles, fits, taxon, option_types, options)
    p = Spree::Product.find_or_initialize_by_name(attrs[:name])
    p.update_attributes attrs
    create_customizations(p, styles, 'style')
    create_customizations(p, fits, 'fit')
    p.taxons << taxon unless p.taxons.include?(taxon)
    option_types.each do |ot|
      p.option_types << ot unless p.option_types.include?(ot)
    end
    options[:colours].option_values.each do |colour|
      next if p.product_color_values.exists?(option_value_id: colour.id)
      p.product_color_values.create(option_value: colour, active: true, custom: false)
    end

    options[:sizes].option_values.each do |size|
      sku = p.sku + size.name.gsub('/', '')
      v = p.variants.find_or_create_by_sku(sku) do |variant|
        variant.on_demand = true
        variant.cost_currency = 'USD'
      end
      v.option_values << size unless v.option_values.include?(size)
    end
  end
end
