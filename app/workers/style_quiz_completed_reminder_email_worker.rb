# Email: Goes out 1 week after style profile complete
# note - about 500 profiles created per week.  
class StyleQuizCompletedReminderEmailWorker < BaseEmailMarketingWorker
  def perform(profile_id)
    send_email(UserStyleProfile.find(profile_id))
  end

  def code
    'style_quiz_completed_reminder'
  end

  private

  def send_email(profile)
    notification = EmailNotification.where(spree_user_id: profile.user_id, code: code).first_or_initialize
    if notification.new_record? || notification.updated_at.nil?
      if notification.save
        begin
          MarketingMailer.style_quiz_completed_reminder(profile.user).deliver
        rescue Exception => e
          log_mailer_error(e)
          notification.delete
        end
      end
    end
  end
end
