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
      Spree::ShippingMethod.order('name asc').each_with_index do |shipping_method, index|
        shipping_method.update_column(:position, index.next)
      end
    end
end
