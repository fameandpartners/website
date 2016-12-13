namespace :wedding_atelier do
  task populate_products: :environment do
    taxonomy = Spree::Taxonomy.find_or_create_by_name('Wedding Atelier')
    taxon = taxonomy.taxons.find_or_create_by_name('Base Silhouette')

    sizes = Spree::OptionType.where(name: 'dress-size').first
    # Common option types
    fabrics = find_or_create_option_type('wedding-atelier-fabrics',
                                         'Fabric', %w(Heavy\ Georgette Matt\ Satin))
    lengths = find_or_create_option_type('wedding-atelier-lengths',
                                         'Length', %w(Mini Knee Petti Midi Ankle Floor))
    colour_names = %w(Navy Black Champagne Berry Burgundy Red Watermelon Coral Peach
                      Bright\ Blush Pale\ Pink Lavender Plum Royal\ Blue Cobalt\ Blue Pale\ Blue
                      Aqua Bright\ Turquoise Mint Pale\ Gray)
    colours = find_or_create_option_type('wedding-atelier-colors', 'Colour', colour_names)

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
      description: 'FP2212',
      price: 200,
      hidden: true
    }

    create_customization('strapless', strapless_attrs, strapless_styles,
                          strapless_fits, base_option_types, taxon)

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
      description: 'FP2213',
      price: 200,
      hidden: true
    }

    create_customization('fit-and-flare', fit_and_flare_attrs, fit_and_flare_styles,
                          fit_and_flare_fits, base_option_types, taxon)

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
      description: 'FP2214',
      price: 200,
      hidden: true
    }

    create_customization('shift', shift_attrs, shift_styles,
                          shift_fits, base_option_types, taxon)

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
      description: 'FP2215',
      price: 200,
      hidden: true
    }

    create_customization('slip', slip_attrs, slip_styles,
                          slip_fits, base_option_types, taxon)

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
      description: 'FP2216',
      price: 200,
      hidden: true
    }

    create_customization('wrap', wrap_attrs, wrap_styles,
                          wrap_fits, base_option_types, taxon)

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
      description: 'FP2220',
      price: 200,
      hidden: true
    }

    create_customization('tri-cup', tri_cup_attrs, tri_cup_styles,
                          tri_cup_fits, base_option_types, taxon)

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
      description: 'FP2218',
      price: 200,
      hidden: true
    }

    create_customization('two-piece', two_piece_attrs, two_piece_styles,
                          two_piece_fits, base_option_types, taxon)

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
      description: 'FP2219',
      price: 200,
      hidden: true
    }

    create_customization('multi-way', multi_way_attrs, multi_way_styles,
                          multi_way_fits, base_option_types, taxon)
  end

  def create_customization(silhouette, attrs, styles, fits, base_option_types, taxon)
    style_option_type = find_or_create_option_type("wedding-atelier-#{silhouette}-dress-styles",
                                                  'Style', styles)
    fit_option_type = find_or_create_option_type("wedding-atelier-#{silhouette}-dress-fit",
                                                'Fit', fits)
    option_types = base_option_types + [style_option_type, fit_option_type]
    find_or_create_product(attrs, option_types, taxon)
  end

  def find_or_create_option_type(name, presentation, option_values)
    Spree::OptionType.find_or_create_by_name(name) do |ot|
      ot.presentation = presentation
      option_values.each do |ov_name|
        ov = Spree::OptionValue.find_or_create_by_name(ov_name.parameterize) do |o|
          o.presentation = ov_name
        end
        ot.option_values << ov unless ot.option_values.include? ov
      end
    end
  end

  def find_or_create_product(attrs, option_types, taxon)
    p = Spree::Product.find_or_initialize_by_name(attrs[:name])
    p.update_attributes attrs
    p.taxons << taxon unless p.taxons.include?(taxon)
    option_types.each do |ot|
      p.option_types << ot unless p.option_types.include?(ot)
    end
  end
end
