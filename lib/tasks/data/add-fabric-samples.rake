namespace :data do
  task :add_fabric_samples => :environment do
    catty = Category.where(category: 'Sample').first_or_create( { category: "Sample", subcategory: "Fabric" })

    samples = [
      ['ivory', '0065', 65, 'Ivory.jpg'],
      ['pale-grey', '0179', 179, 'PaleGrey.jpg'],
      ['black', '0025', 25, 'Black.jpg'],
      ['champagne', '0082', 82, 'Champagne.jpg'],
      ['pale-pink', '0057', 57, 'PalePink.jpg'],
      ['blush', '0090', 90, 'Blush.jpg'],
      ['peach', '0039', 39, 'Peach.jpg'],
      ['guava', '0484', 484, 'Guava.jpg'],
      ['red', '0026', 26, 'Red.jpg'],
      ['burgundy', '0089', 89, 'Burgundy.jpg'],
      ['berry', '0164', 164, 'Berry.jpg'],
      ['lilac', '0061', 61, 'Lilac.jpg'],
      ['navy', '0070', 70, 'Navy.jpg'],
      ['royal-blue', '0067', 67, 'RoyalBlue.jpg'],
      ['pale-blue', '0079', 79, 'PaleBlue.jpg'],
      ['mint', '0055', 55, 'Mint.jpg'],
      ['bright-turquoise', '0390', 390, 'BrightTurquoise.jpg'],
      ['sage-green', '0228', 228, 'SageGreen.jpg']
    ]

    # kill kill kill...all old stuff.
    if prd = Spree::Product.find_by_name('Fabric Swatch - Heavy Georgette')
      prd.variants_including_master.each(&:destroy)
      GlobalSku.where(product_name: prd.name).each(&:destroy)
      prd.destroy
    end

    prd = Spree::Product.new(sku: 'fp-sp-102',
                            featured: false,
                            on_demand: true,
                            available_on: Time.now,
                            name: 'Fabric Swatch - Heavy Georgette',
                            description: 'tbd',
                            permalink: 'fabric_swatch_heavy_georgette',
                            price: 1.0)
    prd.category = catty
    prd.save!


    master_variant = prd.master
    # make usd pricing variant
    usd = Spree::Price.find_or_create_by_variant_id_and_currency(master_variant.id, 'USD')
    usd.amount = 5.0
    usd.save!
    # make aus pricing variant
    aud = Spree::Price.find_or_create_by_variant_id_and_currency(master_variant.id, 'AUD')
    aud.amount = 5.0
    aud.save!


    skarray = []
    # do color variants
    samples.each do |samp|
      variant = prd.variants.build

      # make legacy code happies
      fakey_sizey = Spree::OptionValue.find_by_name('US0/AU4')

      color = Spree::OptionValue.find_by_id(samp[2])
      next unless color.present?
      color.image_file_name = samp.last
      color.save

      #make productcolorvalues to make the cart happy
      pcv = ProductColorValue.new.tap do |pcv|
        pcv.product = prd
        pcv.option_value_id = color.id
        pcv.custom = false
      end

      pcv.save!

      variant.option_values = [color, fakey_sizey]
      variant.on_demand = true
      variant.sku = prd.sku.gsub('sp', "sp#{samp[1].to_s}")
      variant.save!

      usd = Spree::Price.find_or_create_by_variant_id_and_currency(variant.id, 'USD')
      usd.amount = 5.0
      usd.save!

      aud = Spree::Price.find_or_create_by_variant_id_and_currency(variant.id, 'AUD')
      aud.amount = 5.0
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
