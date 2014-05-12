# Added to Wishlist: Send email to a user who added something 
# to their wishlist 12 hours after the last addition. 
# Only send the email once to user. Display contents of wishlist, link to home page.

class AddedToWishlistEmailWorker < BaseEmailMarketingWorker
  def perform(user_id)
    send_email(Spree::User.find(user_id))
  rescue Exception => e
    log_mailer_error(e)
  end

  private

  def send_email(user)
    return if user.last_wishlist_notification_sent_at.present?
    user.update_column(:last_wishlist_notification_sent_at, Time.now)
    MarketingMailer.added_to_wishlist(user).deliver
  end
end
