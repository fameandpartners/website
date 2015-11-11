class AddTwoPropertyForDateForAllProducts < ActiveRecord::Migration
  def change
    property1_id = Spree::Property.where(name: "standard_days_for_making").first.id
    property2_id = Spree::Property.where(name: "customised_days_for_making").first.id

    Spree::Product.all.each do |p|
      pp = Spree::ProductProperty.new
      pp.value        = 6
      pp.product_id   = p.id
      pp.property_id  = property1_id
      pp.save

      pp = Spree::ProductProperty.new
      pp.value        = 11
      pp.product_id   = p.id
      pp.property_id  = property2_id
      pp.save
    end
  end
end
