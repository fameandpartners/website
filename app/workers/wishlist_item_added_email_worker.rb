# Business Rule: Goes out 2 days after added to wishlist
# 300 records for 12 days
class WishlistItemAddedEmailWorker < BaseEmailMarketingWorker
  def perform(item_id)
    send_email(WishlistItem.find(item_id))
  end

  def code
    'wishlist_item_added'
  end

  private

  def send_email(item)
    notification = EmailNotification.where(spree_user_id: item.spree_user_id, code: code).first_or_initialize
    if notification.new_record? || notification.updated_at.nil?
      if notification.save
        begin
          MarketingMailer.wishlist_item_added(item.user, item).deliver
        rescue Exception => e
          log_mailer_error(e)
          notification.delete
        end
      end
    end
  end
end

