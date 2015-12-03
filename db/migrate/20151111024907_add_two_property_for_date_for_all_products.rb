class AddTwoPropertyForDateForAllProducts < ActiveRecord::Migration
  def up
    property1_id = Spree::Property.where(name: "standard_days_for_making").first.id
    property2_id = Spree::Property.where(name: "customised_days_for_making").first.id

    Spree::Product.all.each do |p|
      if Spree::ProductProperty.where(product_id: p.id, property_id: property1_id).blank? && Spree::ProductProperty.where(product_id: p.id, property_id: property2_id).blank?
        policy = Policies::ProjectDeliveryDatePolicy.new(p)
        pp = Spree::ProductProperty.new
        if policy.special_order?
          pp.value      = 10
        else
          pp.value      = 5
        end
        pp.product_id   = p.id
        pp.property_id  = property1_id
        pp.save

        pp = Spree::ProductProperty.new
        pp.value        = 10
        pp.product_id   = p.id
        pp.property_id  = property2_id
        pp.save
      end
    end
  end
end
