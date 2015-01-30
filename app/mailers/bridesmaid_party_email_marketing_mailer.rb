class BridesmaidPartyEmailMarketingMailer < ActionMailer::Base
  self.delivery_method = :mandrill if Rails.env.production?

  layout 'mailer'
  default :from => configatron.noreply, :template_path => 'mailers/bridesmaid_party_email_marketing_mailer'

  def share_completed_bridesmaid_profile(user_id, options = {})
    user = Spree::User.find(user_id)

    Slim::Engine.with_options(:pretty => true) do
      mail(
        to: user.email,
        subject: t('emails.subjects.bridesmaid_marketing.share_completed_bridesmaid_profile')
      )
    end
  end

  def bridesmaid_member_not_purchased(user_id, options = {})
    user = Spree::User.find(user_id)

    Slim::Engine.with_options(:pretty => true) do
      mail(
        to: user.email,
        subject: t('emails.subjects.bridesmaid_marketing.bridesmaid_member_not_purchased')
      )
    end
  end

  def concierge_service_offer(user_id, options = {})
    user = Spree::User.find(user_id)

    Slim::Engine.with_options(:pretty => true) do
      mail(
        to: user.email,
        template_name: (user.id.even? ? 'concierge_service_offer_a' : 'concierge_service_offer_b'),
        subject: t('emails.subjects.bridesmaid_marketing.concierge_service_offer')
      )
    end
  end

  def reminder_to_brides(user_id, options = {})
    user = Spree::User.find(user_id)
    Slim::Engine.with_options(:pretty => true) do
      mail(
        to: user.email,
        subject: t('emails.subjects.bridesmaid_marketing.reminder_to_brides')
      )
    end
  end

  def promo_for_bride_with_bridesmaids(user_id, options = {})
    user = Spree::User.find(user_id)
    @bridesmaids_count = options[:bridesmaids_count]
    @bridesmaids_count ||= user.bridesmaid_party_events.order('bridesmaids_count desc').first.try(:bridesmaids_count).to_i

    if @bridesmaids_count <= 3 # 0,1,2,3
      discount = 15
    elsif @bridesmaids_count <= 5 # 4,5
      discount = 20
    else
      discount = 25
    end
    subject = t('emails.subjects.bridesmaid_marketing.promo_for_bride_with_bridesmaids', discount: discount)

    Slim::Engine.with_options(:pretty => true) do
      mail(to: user.email, subject: subject)
    end
  end

  def free_styling_lesson_for_maid_of_honour(user_id, options = {})
    user = Spree::User.find(user_id)
    Slim::Engine.with_options(:pretty => true) do
      mail(
        to: user.email,
        subject: t('emails.subjects.bridesmaid_marketing.free_styling_lesson_for_maid_of_honour')
      )
    end
  end
end
