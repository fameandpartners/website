class AddPositionsToShippingMethods < ActiveRecord::Migration
  def up
    add_column :spree_shipping_methods, :position, :integer, default: 0
    set_positions
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
end
