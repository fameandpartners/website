class AddDeliveryDatesProperty < ActiveRecord::Migration
  def change
    Spree::Property.create(name: "standard_days_for_making", presentation: "Standard days for making")
    Spree::Property.create(name: "customised_days_for_making", presentation: "Customised days for making")
  end
end
