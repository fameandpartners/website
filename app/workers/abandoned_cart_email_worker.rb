# Abandoned Cart: Send email to a user who has added to cart 
# but not purchased within 60min. Only send the email once to user. 
# Display contents of cart with link back to shopping cart page.
class AbandonedCartEmailWorker < BaseEmailMarketingWorker
  def perform(order_id)
    send_email(Spree::Order.find(order_id))
  rescue Exception => e
    log_mailer_error(e)
  end

  private

  def send_email(order)
    return unless %w(cart address payment).include?(order.state)
    return unless order.user.present?
    return unless order.user.last_cart_notification_sent_at.blank?

    order.user.update_column(:last_cart_notification_sent_at, Time.now)
    MarketingMailer.abandoned_cart(order, order.user).deliver
  end
end

Spree::User.update_all(last_cart_notification_sent_at: nil)
order = Spree::Order.includes(:line_items).last
AbandonedCartEmailWorker.perform_async(order.id)
#AbandonedCartEmailWorker.new.perform(order.id)
