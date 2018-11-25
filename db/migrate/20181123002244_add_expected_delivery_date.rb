class AddExpectedDeliveryDate < ActiveRecord::Migration
  def change
    add_column :making_options, :delivery_time_days, :integer
    add_column :making_options, :cny_delivery_time_days, :integer

    MakingOption.find_or_create_by_code('M7D').update_attributes(delivery_time_days: 7)
    MakingOption.find_or_create_by_code('M10D').update_attributes(delivery_time_days: 10)
    MakingOption.find_or_create_by_code('M3W').update_attributes(delivery_time_days: 21)
    MakingOption.find_or_create_by_code('M10W').update_attributes(delivery_time_days: 70)
    MakingOption.find_or_create_by_code('M6W').update_attributes(delivery_time_days: 42)
  end
end
