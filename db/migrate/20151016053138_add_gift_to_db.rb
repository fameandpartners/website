class AddGiftToDb < ActiveRecord::Migration
  def up
    p = Spree::Product.create(name: 'Gift', price: 0, available_on: Date.yesterday)

    casablanca= Spree::OptionValue.create(name: 'casablanca', presentation: "Casablanca", value:"#7c3340")
    casablanca.option_type_id = 8
    casablanca.save!

    socialite= Spree::OptionValue.create(name: 'socialite', presentation: "Socialite", value:"#c13c38")
    socialite.option_type_id = 8
    socialite.save!

    morocco= Spree::OptionValue.create(name: 'morocco', presentation: "Morocco", value:"#98524d")
    morocco.option_type_id = 8
    morocco.save!

    firered= Spree::OptionValue.create(name: 'firered', presentation: "FireRed", value:"#942529")
    firered.option_type_id = 8
    firered.save!

    casablanca_v= Spree::Variant.create(product_id: p.id, sku:'gift-Color:Casablanca')
    socialite_v= Spree::Variant.create(product_id: p.id, sku:'gift-Color:Socialize')
    morocco_v= Spree::Variant.create(product_id: p.id, sku:'gift-Color:Morocco')
    firered_v= Spree::Variant.create(product_id: p.id, sku:'gift-Color:FireRed')

    sql = "INSERT INTO \"spree_option_values_variants\" (\"variant_id\", \"option_value_id\") VALUES (#{casablanca_v.id},#{casablanca.id})"
    ActiveRecord::Base.connection.execute(sql)

    sql = "INSERT INTO \"spree_option_values_variants\" (\"variant_id\", \"option_value_id\") VALUES (#{socialite_v.id},#{socialite.id})"
    ActiveRecord::Base.connection.execute(sql)

    sql = "INSERT INTO \"spree_option_values_variants\" (\"variant_id\", \"option_value_id\") VALUES (#{morocco_v.id},#{morocco.id})"
    ActiveRecord::Base.connection.execute(sql)

    sql = "INSERT INTO \"spree_option_values_variants\" (\"variant_id\", \"option_value_id\") VALUES (#{firered_v.id},#{firered.id})"
    ActiveRecord::Base.connection.execute(sql)
  end

  def down
    Spree::Product.where(name: 'Gift').first.destroy
    Spree::OptionValue.where(name: 'casablanca').first.destroy
    Spree::OptionValue.where(name: 'socialite').first.destroy
    Spree::OptionValue.where(name: 'morocco').first.destroy
    Spree::OptionValue.where(name: 'firered').first.destroy
  end
end
