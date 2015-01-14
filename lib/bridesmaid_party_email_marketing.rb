# dev shortcuts to copy-paste
# BridesmaidPartyEmailMarketing.send_emails
#
# require 'sidekiq/api'
# Sidekiq::Queue.new.clear
=begin
 # to send all emails:
 BridesmaidPartyEmailMarketing.enabled_mail_codes.each do |code|
   BridesmaidPartyEmailMarketingMailer.send(code, user_id = 1, options = {}).deliver
 end

 # to test scheduling all emails [ forces delete notifications ]
  Sidekiq::Queue.new.clear
  user = Spree::User.find(21029)
  user.email_notifications.delete_all
  BridesmaidPartyEmailMarketing.enabled_mail_codes.each do |code|
    BridesmaidPartyEmailMarketing.schedule_notification(code, 21029, { bridesmaids_count: 3 })
  end
=end

class BridesmaidPartyEmailMarketing
  # for validation/dev/testing purposes
  def self.enabled_mail_codes
    [
      'share_completed_bridesmaid_profile',
      'bridesmaid_member_not_purchased',
      'concierge_service_offer',
      'reminder_to_brides',
      'promo_for_bride_with_bridesmaids',
      'free_styling_lesson_for_maid_of_honour',
    ]
  end

  def self.send_emails
    #Brides who have completed the process, but did not share to bridesmaid
    #Purpose: to get users to share mood board + bridesmaid to start selecting
    #Timing: 1 week after signing up
    with_exceptions_handle { send_share_completed_bridesmaid_profile }

    #Brides or bridesmaids who have not purchased
    #Purpose: Remind signed up users to purchase dress + reminding them of offer
    #Timing: 8 weeks before wedding date
    with_exceptions_handle { send_offer_to_bridesmaid_not_purchased_dress_to_wedding }
    
    #Brides or bridesmaids who have not purchased
    #Purpose: letting them know about concierge service
    #Timing: 2 weeks after signing up, excluding users that are also 6 weeks prior to wedding 
    with_exceptions_handle { send_concierge_service_offer }

    #User who selected "I'm the bride" when they signed up
    #Purpose: to get her buying an engagement dress
    #Timing: 2-3 days after signing up
    with_exceptions_handle { send_emails_to_brides }
  
    #Bride who selected "no. of bridesmaids"
    #Purpose: offering a discount for multiple dresses - 
    # depending on how many bridesmaid they have they will receive a different email
    #Timing: 4 days after sign up
    #Up to 3 bridesmaids – take 15% OFF
    #Up to 5 bridesmaids – take 20% OFF
    #More than 5 bridesmaids – take 25% OFF
    with_exceptions_handle { send_emails_to_brides_with_bridesmaids }
 
    #User who selected "Maid of Honour" and "Who is paying > individual bridesmaids"
    #Purpose: offering a free styling session
    #Timing: 1 week after signup
    with_exceptions_handle { send_emails_to_maid_of_honour }
  end

  #Brides who have completed the process, but did not share to bridesmaid
  #Purpose: to get users to share mood board + bridesmaid to start selecting
  #Timing: 1 week after signing up
  def self.send_share_completed_bridesmaid_profile
    code = 'share_completed_bridesmaid_profile'
    registered_after  = 1.month.ago
    registered_before = 1.week.ago

    query = <<-query
      SELECT bridesmaid_party_events.id as event_id, bridesmaid_party_members.id as member_id
      FROM bridesmaid_party_events 
        LEFT OUTER JOIN bridesmaid_party_members ON bridesmaid_party_events.id = bridesmaid_party_members.event_id
        INNER JOIN spree_users ON bridesmaid_party_events.spree_user_id = spree_users.id
      WHERE bridesmaid_party_members.id IS NULL and spree_users.created_at > ? and spree_users.created_at < ?
    query
    event_ids = BridesmaidParty::Event.find_by_sql([query, registered_after, registered_before]).map(&:event_id)

    BridesmaidParty::Event.where(id: event_ids).find_in_batches(batch_size: 10) do |group|
      group.each do |event|
        if event.completed?
          schedule_notification(code, event.spree_user_id)
        end
      end
    end
  end

  #Brides or bridesmaids who have not purchased
  #Purpose: Remind signed up users to purchase dress + reminding them of offer
  #Timing: 8 weeks before wedding date
  def self.send_offer_to_bridesmaid_not_purchased_dress_to_wedding
    code = 'bridesmaid_member_not_purchased'
    wedding_before  = 2.month.from_now
    wedding_after   = 7.weeks.from_now

    events = BridesmaidParty::Event.includes(:members).
      where("bridesmaid_party_events.wedding_date IS NOT NULL").
      where("bridesmaid_party_events.wedding_date > ?", wedding_after).
      where("bridesmaid_party_events.wedding_date < ?", wedding_before)

    events.find_in_batches(batch_size: 10) do |group|
      group.each do |event|
        # check bride only
        if !user_bought_something?(event.spree_user_id)
          schedule_notification(code, event.spree_user_id)
        end
        if !event.paying_for_bridesmaids?
          event.members.each do |bridesmaid_membership|
            if !user_bought_something?(bridesmaid_membership.spree_user_id)
              schedule_notification(code, bridesmaid_membership.spree_user_id)
            end
          end
        end
      end
    end
  end

  #Brides or bridesmaids who have not purchased
  #Purpose: letting them know about concierge service
  #Timing: 2 weeks after signing up, excluding users that are also 6 weeks prior to wedding 
  def self.send_concierge_service_offer
    code = 'concierge_service_offer'

    registered_before = 2.weeks.ago
    wedding_after = 6.weeks.from_now

    query = <<-query
      SELECT bridesmaid_party_events.id as event_id
      FROM bridesmaid_party_events 
        INNER JOIN spree_users ON bridesmaid_party_events.spree_user_id = spree_users.id
      WHERE spree_users.created_at < ?
        AND (bridesmaid_party_events.wedding_date IS NULL or bridesmaid_party_events.wedding_date > ?)
    query
    event_ids = BridesmaidParty::Event.find_by_sql([query, registered_before, wedding_after]).map(&:event_id)

    BridesmaidParty::Event.where(id: event_ids).find_in_batches(batch_size: 10) do |group|
      group.each do |event|
        # check bride only
        if !user_bought_something?(event.spree_user_id)
          schedule_notification(code, event.spree_user_id)
        end
        if !event.paying_for_bridesmaids?
          event.members.each do |bridesmaid_membership|
            if !user_bought_something?(bridesmaid_membership.spree_user_id)
              schedule_notification(code, bridesmaid_membership.spree_user_id)
            end
          end
        end
      end
    end
  end

  #User who selected "I'm the bride" when they signed up
  #Purpose: to get her buying an engagement dress
  #Timing: 2-3 days after signing up
  def self.send_emails_to_brides
    code = 'reminder_to_brides'
    registered_before = 3.days.ago

    im_bride_status = 2 # BridesmaidParty::Event::STATUSES

    query = <<-query
      SELECT spree_users.id as user_id
      FROM bridesmaid_party_events 
        INNER JOIN spree_users ON bridesmaid_party_events.spree_user_id = spree_users.id
      WHERE spree_users.created_at < ? AND bridesmaid_party_events.status = ?
    query
    user_ids = BridesmaidParty::Event.find_by_sql([query, registered_before, im_bride_status]).map(&:user_id)

    user_ids.each do |spree_user_id|
      schedule_notification(code, spree_user_id)
    end
  end

  #Bride who selected "no. of bridesmaids"
  #Purpose: offering a discount for multiple dresses - 
  # depending on how many bridesmaid they have they will receive a different email
  #Timing: 4 days after sign up
  #Up to 3 bridesmaids – take 15% OFF
  #Up to 5 bridesmaids – take 20% OFF
  #More than 5 bridesmaids – take 25% OFF
  def self.send_emails_to_brides_with_bridesmaids
    code = 'promo_for_bride_with_bridesmaids'
    registered_before = 4.days.ago

    query = <<-query
      SELECT bridesmaid_party_events.id as event_id
      FROM bridesmaid_party_events 
        INNER JOIN spree_users ON bridesmaid_party_events.spree_user_id = spree_users.id
      WHERE spree_users.created_at < ? AND bridesmaid_party_events.bridesmaids_count > 0
    query
    event_ids = BridesmaidParty::Event.find_by_sql([query, registered_before]).map(&:event_id)
    events = BridesmaidParty::Event.where(id: event_ids)

    BridesmaidParty::Event.where(id: event_ids).includes(:members).find_in_batches(batch_size: 10) do |group|
      group.each do |event|
        #bridesmaids_count = event.members.where("spree_user_id is not null").count
        bridesmaids_count = event.bridesmaids_count.to_i || 0
        schedule_notification(code, event.spree_user_id, { bridesmaids_count: bridesmaids_count })
        event.members.each do |event_membership|
          schedule_notification(code, event_membership.spree_user_id, { bridesmaids_count: bridesmaids_count })
        end
      end
    end
  end

  #User who selected "Maid of Honour" and "Who is paying > individual bridesmaids"
  #Purpose: offering a free styling session
  #Timing: 1 week after signup
  def self.send_emails_to_maid_of_honour
    code = 'free_styling_lesson_for_maid_of_honour'
    registered_before = 1.week.ago

    im_the_maid_of_honour_status = 3 # BridesmaidParty::Event::STATUSES

    query = <<-query
      SELECT spree_users.id as user_id
      FROM bridesmaid_party_events 
        INNER JOIN spree_users ON bridesmaid_party_events.spree_user_id = spree_users.id
      WHERE spree_users.created_at < ?
        AND bridesmaid_party_events.status = ?
        AND not bridesmaid_party_events.paying_for_bridesmaids
    query
    user_ids = BridesmaidParty::Event.find_by_sql([query, registered_before, im_the_maid_of_honour_status]).map(&:user_id)

    user_ids.each do |spree_user_id|
      schedule_notification(code, spree_user_id)
    end
  end

  private

  class << self
    def with_exceptions_handle
      yield
    rescue Exception => error
      Rails.logger.info('bridesmaid_party_email_marketing error')
      Rails.logger.info(error.inspect)
      Rails.logger.info(error.backtrace)
    end

    # strictly, concierge service is not dress, but if user bought service product,
    # it's already knows about us
    def user_bought_something?(user_id)
      Spree::Order.where(user_id: user_id, state: 'complete').exists?
    end

    def already_sent?(code, user_id)
      EmailNotification.where(code: code, spree_user_id: user_id).exists?
    end

    # TODO - we should also check EmailNotification presence before sent
    def schedule_notification(code, user_id, options = {})
      return false if already_sent?(code, user_id)
      puts "---- triggered email #{ code } for user #{ user_id } ( #{ options.inspect })"
      BridesmaidPartyEmailMarketingWorker.perform_async(code, user_id, options)
    end
  end
end
