class UpdateLineItemMakingOptions < ActiveRecord::Migration
  def up
    LineItemMakingOption.where(line_item_id: nil).each do |line_item_making_option|
      line_item_id = line_item_making_option.product_id
      product_id = line_item_making_option.variant.try(:product_id)

      line_item_making_option.update_column(:line_item_id, line_item_id)
      line_item_making_option.update_column(:product_id, product_id)
    end
  end

  def down
    # we shouldn't return back
  end
end
