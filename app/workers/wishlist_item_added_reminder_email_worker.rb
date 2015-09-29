# Business rule: Goes out 2 weeks after added to wishlist, if they have not purchased
class WishlistItemAddedReminderEmailWorker < BaseEmailMarketingWorker
  def perform(item_id)
    send_email(WishlistItem.find(item_id))
  end

  def code
    'wishlist_item_added_reminder'
  end

  private

  def send_email(item)
    return if user_purchased_product?(item.spree_user_id, item.spree_product_id)
    notification = EmailNotification.where(spree_user_id: item.spree_user_id, code: code).first_or_initialize
    if notification.new_record? || notification.updated_at.nil?
      if notification.save
        begin
          MarketingMailer.wishlist_item_added_reminder(item.user, item).deliver
        rescue Exception => e
          log_mailer_error(e)
          #notification.delete
        end
      end
    end
  end

  # helper methods
  def user_purchased_product?(user_id, product_id)
    base_scope = Spree::Order.
      includes(line_items: :variant).
      where(user_id: user_id, state: 'complete').
      where('spree_variants.product_id = ?', product_id)
    base_scope.exists?
  end
end
