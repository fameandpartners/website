class AddTwoPropertyForDateForAllProducts < ActiveRecord::Migration
  def change
    property1_id = Spree::Property.where(name: "standard_days_for_making").first.id
    property2_id = Spree::Property.where(name: "customised_days_for_making").first.id

    Spree::Product.all.each do |p|

      policy = Policies::ProjectDeliveryDatePolicy.new(p)
      pp = Spree::ProductProperty.new
      if policy.special_order?
        pp.value      = 11
      else
        pp.value      = 6
      end
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
