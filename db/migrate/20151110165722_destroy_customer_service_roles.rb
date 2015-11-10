class DestroyCustomerServiceRoles < ActiveRecord::Migration
  def up
    if (r = Spree::Role.where(name: 'customer_service').first)
      r.destroy
    end

    if (r = Spree::Role.where(name: 'order_processing').first)
      r.destroy
    end
  end

  def down
    Spree::Role.create(name: 'customer_service')
    Spree::Role.create(name: 'order_processing')
  end
end
