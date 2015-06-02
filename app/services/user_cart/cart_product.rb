##
# service to update single product position in cart
# now supported
#   - customization removal
#   - making option removal
#
# usage
#    product_updater = UserCart::CartProduct.new(
#      order: current_order(true),
#      line_item_id: params[:id]
#
module UserCart; end
class UserCart::CartProduct
  attr_reader :order, :line_item

  def initialize(options = {})
    @order = options[:order]
    @line_item = order.line_items.where(id: options[:line_item_id]).first
  end

  def destroy
    if line_item.present?
      line_item.destroy
      update_order
    end
  end

  def destroy_customization(id)
    return true if line_item.personalization.blank?

    line_item.personalization.customization_value_ids.delete_if{|customization_id| customization_id.to_i == id.to_i }
    line_item.personalization.recalculate_price
    line_item.personalization.save
    update_order

    true
  end

  def destroy_making_option(id)
    making_option = line_item.making_options.where(id: id).first
    if making_option.present?
      making_option.destroy
      update_order
    end
    true
  end

  private

    def update_order
      line_item.touch if line_item.persisted?
      order.clean_cache!
      order.update!
      order.reload
    end
end
