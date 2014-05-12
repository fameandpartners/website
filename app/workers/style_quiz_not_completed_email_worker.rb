class StyleQuizNotCompletedEmailWorker < BaseEmailMarketingWorker
  def perform(user_id)
    send_email(Spree::User.find(user_id))
  rescue Exception => e
    log_mailer_error(e)
  end

  private

  def send_email(user)
    return if user.last_quiz_notification_sent_at.present?
    if user.update_column(:last_quiz_notification_sent_at, Time.now)
      MarketingMailer.style_quiz_not_completed(user).deliver
    end
  end
end
