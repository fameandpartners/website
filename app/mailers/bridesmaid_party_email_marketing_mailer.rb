class BridesmaidPartyEmailMarketingMailer < ActionMailer::Base
  self.delivery_method = :mandrill if Rails.env.production?

  layout 'mailer'
  default :from => configatron.noreply, :template_path => 'mailers/bridesmaid_party_email_marketing_mailer'

  def share_completed_bridesmaid_profile(user_id, options = {})
    user = Spree::User.find(user_id)
    mail(
      to: user.email,
      subject: "It's time to reveal your secret!"
    )
  end

  def bridesmaid_member_not_purchased(user_id, options = {})
    user = Spree::User.find(user_id)
    mail(
      to: user.email,
      subject: "Forgetting something? Tick 'Bridesmaids dresses' off your list & purchase with 15% OFF!"
    )
  end

  def concierge_service_offer(user_id, options = {})
    user = Spree::User.find(user_id)
    mail(
      to: user.email,
      template_name: (user.id.even? ? 'concierge_service_offer_a' : 'concierge_service_offer_b'),
      subject: 'Help us, help you! For just $99 we can take the stress & organise bridesmaids dresses'
    )
  end

  def reminder_to_brides(user_id, options = {})
    user = Spree::User.find(user_id)
    mail(
      to: user.email,
      subject: "Now you have the ring, it's time for a dress! 15% OFF your engagement dress!"
    )
  end

  def promo_for_bride_with_bridesmaids(user_id, options = {})
    user = Spree::User.find(user_id)
    @bridesmaids_count = options[:bridesmaids_count]
    @bridesmaids_count ||= user.bridesmaid_party_events.order('bridesmaids_count desc').first.try(:bridesmaids_count).to_i

    if @bridesmaids_count < 3
      subject = "Help has arrived. Take 15% OFF your bridesmaids' dresses & take away the stress!"
    elsif @bridesmaids_count < 5
      subject = "Help has arrived. Take 20% OFF your bridesmaids' dresses & take away the stress!"
    else
      subject = "Help has arrived. Take 25% OFF your bridesmaids' dresses & take away the stress!"
    end

    mail(to: user.email, subject: subject)
  end

  def free_styling_lesson_for_maid_of_honour(user_id, options = {})
    user = Spree::User.find(user_id)
    mail(
      to: user.email,
      subject: "Maid of Honour duties taking a toll? Here's a FREE styling session to kick start the Bridal Party!"
    )
  end
end
