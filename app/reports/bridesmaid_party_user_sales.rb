# description ( from task )
# Apparently we are tracking all users who have signed up via the bridesmaids microsite.
# We would like to have a report on what % of these users have then purchased?

# usage:
# load File.join(Rails.root, 'app', 'reports', 'bridesmaid_party_user_sales.rb')
# Reports::BridesmaidPartyUserSales.new().report

module Reports; end
class Reports::BridesmaidPartyUserSales
  def initialize
  end

  def report
    @report ||= FastOpenStruct.new(
      fields: report_fields,
      users:  bridesmaid_party_registered_users,
      average: calculate_averages(bridesmaid_party_registered_users)
    )
  end

  private
    
    def report_fields
      [
        'bridesmaids_count', 
        'bridesmaids_registered',
        'paying_for_bridesmaids',
        'bride_purchased',
        'bridesmaids_purchased'
      ]
    end

    def bridesmaid_party_registered_users
      @bridesmaid_party_registered_users ||= begin
        BridesmaidParty::Event.includes(:spree_user, members: :spree_user).map do |event|
          registered_members = event.members.map{|m| m.spree_user }.compact

          FastOpenStruct.new(
            bridesmaids_count: event.bridesmaids_count,
            bridesmaids_registered: registered_members.size,
            paying_for_bridesmaids: event.paying_for_bridesmaids,
            bride_purchased:  is_user_bought_something?(event.spree_user),
            bridesmaids_purchased: is_user_bought_something?(registered_members)
          )
        end
      end
    end

    def is_user_bought_something?(users)
      user_ids = Array.wrap(users).map(&:id)

      # if where exists completed  orders with given user ids
      Spree::Order.where(user_id: user_ids, state: 'complete').exists?
    end

    def calculate_averages(users)
      if users.blank?
        return FastOpenStruct.new()
      end

      FastOpenStruct.new(
        bridesmaids_count: (users.sum(&:bridesmaids_count) / users.size.to_f),
        bridesmaids_registered: (users.sum(&:bridesmaids_registered) / users.size.to_f),
        paying_for_bridesmaids: users.count(&:paying_for_bridesmaids) * 100 / users.size.to_f,
        bride_purchased: users.count(&:bride_purchased) * 100 / users.size.to_f,
        bridesmaids_purchased: users.count(&:bridesmaids_purchased) * 100 / users.size.to_f
      )
    end
end
