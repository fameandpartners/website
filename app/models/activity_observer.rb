class ActivityObserver < ActiveRecord::Observer
  observe WishlistItem, Spree::LineItem

  def after_create(record)
    case record.class.to_s
    when 'WishlistItem'
      Activity.log_product_added_to_wishlist(record.product, record.user, record)
#    when 'Spree::LineItem'
#      #!!!!!current order don't have current user...
#      order = record.order
#      Activity.log_product_added_to_cart(record.product, order.user, record)
    end
  rescue Exception => e
    record.logger.error("#{e.class.name}: #{e.message}")
    record.logger.error(e.backtrace * "\n")
  end

  def after_destroy(record)
    case record.class.to_s
    when 'Spree::LineItem'
      product = record.product
      order = record.order
      activity = Activity.where(
        action: 'added_to_cart',
        owner_id: product.id, owner_type: product.class.to_s,
        item_id: order.id, item_type: order.class.to_s
      ).first
      return if activity.nil?
      if activity.try(:number).to_i > 0
        Activity.where(id: activity.id).update_all(number: (activity.number.to_i - 1))
      else
        activity.destroy
      end
    end
  rescue Exception => e
    record.logger.error("#{e.class.name}: #{e.message}")
    record.logger.error(e.backtrace * "\n")
  end
end
