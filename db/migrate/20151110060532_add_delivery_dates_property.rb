class AddDeliveryDatesProperty < ActiveRecord::Migration
  def up
    Spree::Property.create(name: "standard_days_for_making", presentation: "Standard days for making") if Spree::Property.where(name: "standard_days_for_making").blank?
    Spree::Property.create(name: "customised_days_for_making", presentation: "Customised days for making") if Spree::Property.where(name: "customised_days_for_making").blank?
  end
end
