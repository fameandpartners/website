class StyleQuizCompletedEmailWorker < BaseEmailMarketingWorker
  def perform(user_id, site_version_id = nil)
    site_version = site_version_id.present? ? SiteVersion.find_by_id(site_version_id) : nil
    send_email(Spree::User.find(user_id), site_version)
  rescue Exception => e
    log_mailer_error(e)
  end

  private

  def send_email(user, site_version)
    MarketingMailer.style_quiz_completed(user, site_version)
  end
end
