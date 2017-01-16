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
      'Add sheer draped panel to bodice',
      'Add wide off shoulder panel',
      'Add separate cape',
      'Add separate wide tie belt',
      'Add draped arm bows'
    ]

    strapless_fits = [
      'Add wide bow straps',
      'Change to one shoulder neckline',
      'Add flred hem ruffle',
      'Add narrow adjusatble straps',
      'Change to Hi-low hem skirt with full volume silhouette'
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
      'Add 2-layer cape (attached)',
      'Add single sleeve with cuff',
      'Add bow to shoulder',
      'Add flared arm bands',
      'Add separate wide tie belt'
    ]

    fit_and_flare_fits = [
      'Change to spaghetti straps',
      'Change to halter neckline',
      'Change to strapless neckline',
      'Change to scoop neck',
      'Change to hi-low hem'
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
      'Add long fitted sleeves with shoulder cut-outs',
      'Add draped side arm panels (attached to side seam)',
      'Add wide off shoulder panel',
      'Add long flared sleeve',
      'Add separate wide tie belt'
    ]

    shift_fits = [
      'Change to plunging back neckline',
      'Change to plunging neckline',
      'Change to one shoulder neckline',
      'Change to classic neckline',
      'Change to a-line silhouette'
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
      'Add hem ruffle',
      'Add cape (longer with arm splits)',
      'Add long flared sleeve',
      'Add separate wide tie belt',
      'Add draped arm bows'
    ]

    slip_fits = [
      'Change to multi back straps',
      'Change to rouleau straps',
      'Change to round back neck',
      'Change to v neck',
      'Change to side split'
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
      'Add separate wide tie belt',
      'Add cape (longer with arm splits)',
      'Add long flared sleeve',
      'Add wide arm ties',
      'Add voluminous half sleeve'
    ]

    wrap_fits = [
      'Change to rouleau straps',
      'Add hem ruffle',
      'Change to v wrap back neckline',
      'Change to a-line skirt',
      'Add double hem ruffle'
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
      'Add separate cape',
      'Change to tie straps (remove ring + slide)',
      'Add ruffles to cups',
      'Add ruffles to steams',
      'Add detachable bow'
    ]

    tri_cup_fits = [
      'Change to column skirt',
      'Change to wide straps',
      'Change cross back straps with bow',
      'Change to babydoll silhouette',
      'Add double hem ruffle'
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
      'Add ruffle to bodice edge',
      'Add back neck bow tie',
      'Add side ties (bow at back)',
      'Add wide arm ties',
      'Add draped cold shoulder sleeve'
    ]

    two_piece_fits = [
      'Add hem ruffle',
      'Change to strapless bodice',
      'ADd front keyhole',
      'Change to column skirt',
      'Change to classic bodice with short sleeve'
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
      'Add ruffle down skirt edge',
      'Add rufle down front neckline',
      'Add arm ties (not wide)'
    ]

    multi_way_fits = [
      'Change to full volume skirt',
      'Remove overlapping skirt panel',
      'Change to hi-low hem',
      'Raise front and back neckline',
      'Change to column skirt'
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
                                          presentation: c,
                                          customisation_type: customization_type,
                                          price: 10
                                          )
    end
    binding.pry
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
