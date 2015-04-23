class AddCustomerServiceRole < ActiveRecord::Migration
  def up
    Spree::Role.create(name: 'customer_service')
    Spree::Role.create(name: 'order_processing')
  end

  def down

    if r = Spree::Role.where(name: 'customer_service').first
      r.delete
    end

    if r = Spree::Role.where(name: 'order_processing').first
      r.delete
    end

  end
end
