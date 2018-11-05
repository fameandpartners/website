namespace :data do
  desc 'migrate images'
  task :migrate_image => :environment do
    Fabric.all.each do |fabric|
      begin
        next unless fabric.image_url

        image_path = fabric.image_url.sub(/http(.*)cloudfront.net\/assets\//, '')
        image = File.open("app/assets/images/#{image_path}")
        fabric.image = image
        fabric.save!

        image.close
      rescue StandardError => e
        puts "Error fabric #{fabric.name}"
        puts e
      end
    end

    puts "Done"
  end


  desc 'set production code'
  task :set_fabric_production_code => :environment do
    Fabric.where(material: 'Bonded Scuba').update_all(production_code: 132)
    Fabric.where(material: 'Broiderie Anglaise Wave').update_all(production_code: 216)
    Fabric.where(material: 'Brushed Twill').update_all(production_code: 144)
    Fabric.where(material: 'Corded Lace').update_all(production_code: 601)
    Fabric.where(material: 'Cotton Poplin').update_all(production_code: 220)
    Fabric.where(material: 'Cotton Poplin Gingham').update_all(production_code: 215)
    Fabric.where(material: 'Cotton Poplin Stripe').update_all(production_code: 209)
    Fabric.where(material: 'Cotton Sateen').update_all(production_code: 202)
    Fabric.where(material: 'Crepe Suiting').update_all(production_code: 127)
    Fabric.where(material: 'Double Windowpane Suiting').update_all(production_code: 142)
    Fabric.where(material: 'Drapey Glossy Sequin').update_all(production_code: 905)
    Fabric.where(material: 'Duchess Satin').update_all(production_code: 108)
    Fabric.where(material: 'Even Stripe Shirting').update_all(production_code: 248)
    Fabric.where(material: 'Glen Plaid Suiting').update_all(production_code: 138)
    Fabric.where(material: 'Glossy Sequin').update_all(production_code: 901)
    Fabric.where(material: 'Heavy Georgette').update_all(production_code: 102)
    Fabric.where(material: 'Heavy Poly Twill').update_all(production_code: 118)
    Fabric.where(material: 'Heavy Silk Charmeuse').update_all(production_code: 253)
    Fabric.where(material: 'Heavy Stretch Linen').update_all(production_code: 236)
    Fabric.where(material: 'Houndstooth Suiting').update_all(production_code: 139)
    Fabric.where(material: 'Light Chiffon').update_all(production_code: 103)
    Fabric.where(material: 'Light Georgette').update_all(production_code: 101)
    Fabric.where(material: 'Light Silk Charmeuse').update_all(production_code: 251)
    Fabric.where(material: 'Linear Spot Tulle').update_all(production_code: 713)
    Fabric.where(material: 'Linen').update_all(production_code: 237)
    Fabric.where(material: 'Matte Satin').update_all(production_code: 107)
    Fabric.where(material: 'Matte Stretch Woven').update_all(production_code: 115)
    Fabric.where(material: 'Medium Matte Satin').update_all(production_code: 145)
    Fabric.where(material: 'Medium Silk Charmeuse').update_all(production_code: 252)
    Fabric.where(material: 'Metallic Coated Georgette').update_all(production_code: 112)
    Fabric.where(material: 'Metallic Woven Satin').update_all(production_code: 119)
    Fabric.where(material: 'Multi Stripe Shirting').update_all(production_code: 267)
    Fabric.where(material: 'Narrow Stripe Shirting').update_all(production_code: 249)
    Fabric.where(material: 'Pearl Chiffon').update_all(production_code: 113)
    Fabric.where(material: 'Poly Stretch Suiting').update_all(production_code: 117)
    Fabric.where(material: 'Power Mesh').update_all(production_code: 722)
    Fabric.where(material: 'Raised Spot Georgette').update_all(production_code: 130)
    Fabric.where(material: 'Sandwashed Silk').update_all(production_code: 250)
    Fabric.where(material: 'Satin Back Twill').update_all(production_code: 106)
    Fabric.where(material: 'Shimmer Woven').update_all(production_code: 131)
    Fabric.where(material: 'Silk Viscose Velvet').update_all(production_code: 801)
    Fabric.where(material: 'Soft Tencel Suiting').update_all(production_code: 266)
    Fabric.where(material: 'Soft Tulle').update_all(production_code: 701)
    Fabric.where(material: 'Stretch Crepe').update_all(production_code: 105)
    Fabric.where(material: 'Stretch Silk Charmeuse').update_all(production_code: 255)
    Fabric.where(material: 'Tafetta').update_all(production_code: 109)
    Fabric.where(material: 'Textured Poly').update_all(production_code: 134)
    Fabric.where(material: 'Tightly Woven Habotai').update_all(production_code: 218)
    Fabric.where(material: 'Washed Satin').update_all(production_code: 122)
    Fabric.where(material: 'Windowpane Suiting').update_all(production_code: 210)
    Fabric.where(material: 'Fine Stripe Twill').update_all(production_code: 214)
  end
end
