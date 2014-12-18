# dev shortcuts to copy-paste
# BridesmaidPartyEmailMarketing.send_emails
# BridesmaidPartyEmailMarketing.send_share_completed_bridesmaid_profile
#
class BridesmaidPartyEmailMarketing
  def self.send_emails
    #Brides who have completed the process, but did not share to bridesmaid
    #Purpose: to get users to share mood board + bridesmaid to start selecting
    #Timing: 1 week after signing up
    send_share_completed_bridesmaid_profile

    #Brides or bridesmaids who have not purchased
    #Purpose: Remind signed up users to purchase dress + reminding them of offer
    #Timing: 8 weeks before wedding date
    
    #Brides or bridesmaids who have not purchased
    #Purpose: letting them know about concierge service
    #Timing: 2 weeks after signing up, excluding users that are also 6 weeks prior to wedding and/or have received that email already

    #User who selected "I'm the bride" when they signed up
    #Purpose: to get her buying an engagement dress
    #Timing: 2-3 days after signing up
  
    #Bride who selected "no. of bridesmaids"
    #Purpose: offering a discount for multiple dresses - depending on how many bridesmaid they have they will receive a different email
    #Timing: 4 days after sign up
    #Up to 3 bridesmaids – take 15% OFF
    #Up to 5 bridesmaids – take 20% OFF
    #More than 5 bridesmaids – take 25% OFF
 
    #User who selected "Maid of Honour" and "Who is paying > individual bridesmaids"
    #Purpose: offering a free styling session
    #Timing: 1 week after signup
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
        if event.completed? && !EmailNotification.where(code: code, spree_user_id: event.spree_user_id).exists?
          # add worker with email sent
          puts "---- triggered email #{ code } for user #{ event.spree_user_id }"
        end
      end
    end
  end

  private

end
