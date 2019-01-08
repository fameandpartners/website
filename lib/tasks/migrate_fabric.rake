# encoding: utf-8

fabric_mapping = {
'usp1096'	=> ['Duchess Satin'	,'108'],
'c161036'	=> ['Matte Stretch Woven'	,'115'],
'fp2185'	=> ['Matte Satin'	,'107'],
'fp2222'	=> ['Luxe Silk Charmeuse and Delicate Lace'	,'298'],
'fp2224'	=> ['Silk Light Georgette and Delicate Lace'	,'249'],
'fp2229'	=> ['Luxe Silk Charmeuse and Tulle'	,'298'],
'fpmc107'	=> ['Corded Lace'	,'623'],
'fpmc116'	=> ['Cotton Lace and Silk Taffeta'	,'624'],
'fpmc117'	=> ['Delicate Lace, Tulle and Matte Satin'	,'625'],
'fp2301'	=> ['Luxe Silk Charmeuse'	,'298'],
'fp2305'	=> ['Luxe Silk Charmeuse'	,'298'],
'fp2254b'	=> ['Duchess Satin'	,'108'],
'fp2282'	=> ['Matte Satin'	,'107'],
'fp2287'	=> ['Matte Satin'	,'107'],
'fp2300'	=> ['Taffeta'	,'109'],
'fp2220s0f5'	=> ['Heavy Georgette'	,'102'],
'fp2220s4f2'	=> ['Heavy Georgette'	,'102'],
'fp2375'	=> ['Cotton Corded Lace'	,'601'],
'fp2345'	=> ['Medium Linen'	,'2101'],
'fp2351'	=> ['Cotton Sateen'	,'202'],
'fprv1026p'	=> ['Stretch Crepe'	,'105'],
'fp2313'	=> ['Matte Satin'	,'107'],
'fp2365p'	=> ['Heavy Georgette'	,'102'],
'fp2351p'	=> ['Cotton Poplin Stripe'	,'205'],
'fprv1036'	=> ['Cotton Sateen'	,'202'],
'fp2476'	=> ['Heavy Georgette'	,'102'],
'fp2478'	=> ['Light Georgette'	,'101'],
'fp2452'	=> ['Cotton Corded Lace'	,'601'],
'fp2456'	=> ['Matte Satin'	,'107'],
'fp2457'	=> ['Matte Satin and Tulle'	,'107'],
'fp2459'	=> ['Heavy Georgette and Cotton Corded Lace'	,'102'],
'fp2462'	=> ['Cotton Sateen'	,'202'],
'fp2463'	=> ['Heavy Georgette'	,'102'],
'fp2523'	=> ['Sandwashed Silk'	,'250'],
'fp2524'	=> ['Stretch Crepe'	,'105'],
'fp2599b'	=> ['Cotton Corded Lace, Light Georgette and Spot Tulle'	,'601'],
'fp2610b'	=> ['Cotton Corded Lace, Silk Viscose Velvet'	,'601'],
'fp2621'	=> ['Heavy Georgette and Delicate Lace'	,'102'],
'fp2633'	=> ['Light Georgette'	,'101'],
'fprv1132'	=> ['Woven Lurex'	,'165'],
'4B130'	=> ['Taffeta'	,'109'],
'4B396'	=> ['Light Georgette'	,'101'],
}

namespace :migrate do
  task :dedup_fabrics => :environment do
    Fabric.select(:name).group(:name).having("count(*) > 1").each do |fabric|
      fabrics = Fabric.where(name: fabric.name)
      master = fabrics.shift
      dup_ids = fabrics.map(&:id)

      puts "processing #{master.name}, master: #{master.id}, dups: #{dup_ids.join(",")}"

      GlobalSku.where(fabric_id: dup_ids).update_all(fabric_id: master.id)
      Spree::LineItem.where(fabric_id: dup_ids).update_all(fabric_id: master.id)
      FabricsProduct.where(fabric_id: dup_ids).update_all(fabric_id: master.id)

      fabrics.each(&:delete)
    end
  end

  task :dedup_fabrics_products => :environment do
    FabricsProduct.select([:fabric_id, :product_id]).group([:fabric_id, :product_id]).where(active: true).having("count(*) > 1").each do |fabrics_product|
      fabrics_products = FabricsProduct.where(fabric_id: fabrics_product.fabric_id, product_id: fabrics_product.product_id, active: true)
      master = fabrics_products.shift
      dup_ids = fabrics_products.map(&:id)

      puts "processing #{master.product.sku} #{master.fabric.name}, master: #{master.id}, dups: #{dup_ids.join(",")}"

      fabrics_products.each(&:delete)
    end
  end

  task :migrate_fabric => :environment do
    ActiveRecord::Base.transaction do
      products = Spree::Product.active
      products.each do |product|
        if product.fabric_products.any?
          next
        end

        mapping = fabric_mapping[product.sku]
        unless mapping
          puts "!ignoring #{product.sku}"
          next
        end

        material = mapping[0]
        material_code = material.downcase.gsub(" ", "-")
        code = mapping[1]

        puts "processing #{product.sku} - mapping to #{material}"
        product.product_color_values.each do |pcv|
          fabric = Fabric.find_by_presentation("#{pcv.option_value.presentation} #{material}")
          unless fabric
            fabric = Fabric.new
            fabric.presentation = "#{pcv.option_value.presentation} #{material}"
            fabric.name = "#{pcv.option_value.name}-#{material_code}"
            fabric.material = material
            fabric.option_value = pcv.option_value
            fabric.save!

            puts " -creating fabric #{fabric.name}"
          end

          fabric_product = FabricsProduct.new
          fabric_product.fabric = fabric
          fabric_product.product = product
          fabric_product.active = pcv.active
          fabric_product.recommended = !pcv.custom
          fabric_product.description = product.property('fabric')
          fabric_product.price_aud = pcv.custom ? LineItemPersonalization::DEFAULT_CUSTOM_COLOR_PRICE : 0
          fabric_product.price_usd = pcv.custom ? LineItemPersonalization::DEFAULT_CUSTOM_COLOR_PRICE : 0
          fabric_product.save!

          pcv.custom = false
          pcv.save!

          curation =  product.curations.where(pid: Spree::Product.format_new_pid(product.sku, pcv.option_value.name, [])).first
          if curation
            curation.pid = Spree::Product.format_new_pid(product.sku, fabric.name, [])
            curation.save!
          end
        end
      end
    end
  end
end
