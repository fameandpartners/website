class AmendMakingTimes < ActiveRecord::Migration
  def up
      standard_days_for_making_id = Spree::Property.where(name: "standard_days_for_making").first.id
      customised_days_for_making_id = Spree::Property.where(name: "customised_days_for_making").first.id

      days_7 = %w{4b506b 4b557 4B616 4B551 4B251 4B527}
      days_10 = %w{4b559 4b332 4b032 4B639B 4B535 4B548}

      ids = Spree::Variant.select(:product_id).where("UPPER(sku) IN (?)", days_7)

      Spree::Product.where(:id => ids).all.each do |p|
        standard = Spree::ProductProperty.new(property_id: standard_days_for_making_id, product_id: p.id)
        standard.value = 7
        standard.save!

        customized = Spree::ProductProperty.new(property_id: customised_days_for_making_id, product_id: p.id)
        customized.value = 10
        customized.save!
      end

      ids = Spree::Variant.select(:product_id).where("UPPER(sku) IN (?)", days_10)

      Spree::Product.where(:id => ids).all.each do |p|
        standard = Spree::ProductProperty.new(property_id: standard_days_for_making_id, product_id: p.id)
        standard.value = 10
        standard.save!

        customized = Spree::ProductProperty.new(property_id: customised_days_for_making_id, product_id: p.id)
        customized.value = 14
        customized.save!
      end
  end

end
