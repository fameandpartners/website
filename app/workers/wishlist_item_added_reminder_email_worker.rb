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
    base_scope = Activity.where(
      actor_id: user_id, actor_type: 'Spree::User',
      owner_id: product_id, owner_type: 'Spree::Product',
      action: 'purchased'
    )
    base_scope.exists?
  end
end
