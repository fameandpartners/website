# Abandoned Cart: Send email to a user who has added to cart 
# but not purchased within 60min. Only send the email once to user. 
# Display contents of cart with link back to shopping cart page.
class AbandonedCartEmailWorker < BaseEmailMarketingWorker
  def perform(order_id)
    send_email(Spree::Order.find(order_id))
  rescue StandardError => e
    log_mailer_error(e)
  end

  private

  def send_email(order)
    return unless %w(cart address payment).include?(order.state)
    return if order.user.blank?
    return if order.user.last_cart_notification_sent_at.present?

    if order.user.update_column(:last_cart_notification_sent_at, Time.now)
      begin
        NewRelic::Agent.record_custom_event('AbandonedCartEmailDelivery',
                                            order_number: order.number,
                                            email: order.user.email )
      rescue
        # NOOP
      end
      MarketingMailer.abandoned_cart(order, order.user).deliver
    end
  end
end
