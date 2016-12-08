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

    colour_list = [
      'Navy'
    ]
    colours = find_or_create_option_type('wedding-atelier-colors', 'Colour', colour_list)

    # Strapless option types
    styles = [
      'Add sheer draped panel to bodice',
      'Add wide off shoulder panel',
      'Add separate cape',
      'Add separate wide tie belt',
      'Add draped arm bows'
    ]
    strapless_styles = find_or_create_option_type('wedding-atelier-strapless-styles',
                                                  'Style', styles)

    fits = [
      'Add wide bow straps',
      'Change to one shoulder neckline',
      'Add flred hem ruffle',
      'Add narrow adjusatble straps',
      'Change to Hi-low hem skirt with full volume silhouette'
    ]
    strapless_fit = find_or_create_option_type('wedding-atelier-strapless-fit', 'Fit', fits)

    # TODO: Ask for the base price
    attrs = {
      name: 'Strapless Column Dress',
      description: 'FP2212',
      price: 200,
      hidden: true
    }
    option_types = [strapless_styles, strapless_fit, sizes, fabrics, lengths, colours]
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
