class AddPositionsToShippingMethods < ActiveRecord::Migration
  def up
    add_column :spree_shipping_methods, :position, :integer, default: 0
    set_positions
    update_orders
  end

  def down
    remove_column :spree_shipping_methods, :position
  end

  private

    def set_positions
      ordered_shipping_methods.each_with_index do |shipping_method, index|
        shipping_method.update_column(:position, index.next)
      end
    end

    def ordered_shipping_methods
      priorities = { 'DHL' => 3, 'AUSPOST' => 2, 'TNT' => 1 } 
      Spree::ShippingMethod.all.sort_by do |shipping_method|
        [priorities[shipping_method.name].to_i, shipping_method.zone_id]
      end.reverse
    end

    def update_orders
      states = %w{cart address delivery payment}
      Spree::Order.where(state: states).where('shipping_method_id is not null').find_each do |order|
        next if order.payments.exists?
        next if order.shipments.where("state != 'pending'").exists?

        shipping_method_id = Services::FindShippingMethodForOrder.new(order).get.try(:id)
        if shipping_method_id && order.shipping_method_id != shipping_method_id
          order.update_column(:shipping_method_id, shipping_method_id)
          order.shipments = Shipping::AssignByFactory.new(order).create_shipments!
        end
      end
    end
end
