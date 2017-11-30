namespace :data do
  task :add_fabric_samples => :environment do
    catty = Category.new
    catty.category = 'Sample'
    catty.subcategory = 'Fabric'
    catty.save

    samples = [
      ['ivory', '0065', 65],
      ['pale-grey', '0179', 179],
      ['black', '0025', 25],
      ['champagne', '0082', 82],
      ['pale-pink', '0057', 57],
      ['blush', '0090', 90],
      ['peach', '0039', 39],
      ['guava', '0484', 484],
      ['red', '0026', 26],
      ['burgundy', '0089', 89],
      ['berry', '0164', 164],
      ['lilac', '0061', 61],
      ['navy', '0070', 70],
      ['royal-blue', '0067', 67],
      ['pale-blue', '0079', 79],
      ['mint', '0055', 55],
      ['bright-turquoise', '0390', 390],
      ['sage-green', '0228', 228]
    ]

    prd = Spree::Product.new(sku: 'fp-sp-102',
                            featured: false,
                            on_demand: true,
                            available_on: Time.now,
                            name: 'Fabric Swatch - Heavy Georgette',
                            description: 'tbd',
                            permalink: 'fabric_swatch_heavy_georgette',
                            price: 1.0)
    prd.save!

    master_variant = prd.master
    # make usd pricing variant
    usd = Spree::Price.find_or_create_by_variant_id_and_currency(master_variant.id, 'USD')
    usd.amount = 1.0
    usd.save!
    # make aus pricing variant
    aud = Spree::Price.find_or_create_by_variant_id_and_currency(master_variant.id, 'AUD')
    aud.amount = 1.0
    aud.save!


    skarray = []
    # do color variants
    samples.each do |samp|
      variant = prd.variants.build

      color = Spree::OptionValue.find_by_id(samp[2])
      next unless color.present?
      variant.option_values = [color]
      variant.on_demand = true
      variant.sku = prd.sku.gsub('sp', "sp#{samp[1].to_s}")
      variant.save!

      usd = Spree::Price.find_or_create_by_variant_id_and_currency(variant.id, 'USD')
      usd.amount = 1.0
      usd.save!

      aud = Spree::Price.find_or_create_by_variant_id_and_currency(variant.id, 'AUD')
      aud.amount = 1.0
      aud.save!

      gs = GlobalSku.create!(
        sku: variant.sku,
        style_number: prd.master.sku,
        product_name: prd.name,
        color_id: color.id,
        color_name: color.name,
        product_id: prd.id,
        variant_id: variant.id
      )
      skarray << "#{gs.id.to_s}, #{gs.color_name}, #{gs.sku}"
    end

    p skarray

  end

end
