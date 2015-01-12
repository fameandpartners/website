class BridesmaidPartyEmailMarketingWorker < BaseEmailMarketingWorker
  def perform(code, user_id, options = {})
    return if already_send?(code, user_id)
    send_email(code, user_id, options)
    mark_as_sent!(code, user_id)
  rescue Exception => e
    log_mailer_error(e)
  end

  private

  def already_sent?(code, user_id)
    EmailNotification.where(code: code, spree_user_id: user_id).exists?
  end

  def mark_as_sent!(code, user_id)
    EmailNotification.where(code: code, spree_user_id: user_id).first_or_create
  end

  def send_email(code, user_id, options = {})
    BridesmaidPartyEmailMarketingMailer.send(code, user_id, options).deliver
  end
end
