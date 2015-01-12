class BridesmaidPartyEmailMarketingMailer < ActionMailer::Base
  self.delivery_method = :mandrill if Rails.env.production?

  layout 'mailer'
  default :from => configatron.noreply, :template_path => 'mailers/bridesmaid_party_email_marketing_mailer'

  def share_completed_bridesmaid_profile(user_id, options = {})
    mail(to: 'user@example.com', subject: 'Bridesmaid Party Email Marketing')
  end

  def bridesmaid_member_not_purchased(user_id, options = {})
    mail(to: 'user@example.com', subject: 'Bridesmaid Party Email Marketing')
  end

  def concierge_service_offer(user_id, options = {})
    mail(to: 'user@example.com', subject: 'Bridesmaid Party Email Marketing')
  end

  def reminder_to_brides(user_id, options = {})
    mail(to: 'user@example.com', subject: 'Bridesmaid Party Email Marketing')
  end

  def promo_for_bride_with_bridesmaids(user_id, options = {})
    mail(to: 'user@example.com', subject: 'Bridesmaid Party Email Marketing')
  end

  def free_styling_lesson_for_maid_of_honour(user_id, options = {})
    mail(to: 'user@example.com', subject: 'Bridesmaid Party Email Marketing')
  end
end
