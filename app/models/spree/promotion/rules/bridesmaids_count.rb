# A rule to apply to an order when user is bride or bridesmaid
module Spree
  class Promotion
    module Rules
      class BridesmaidsCount < PromotionRule
        preference :count, :integer

        attr_accessible :preferred_count

        def eligible?(order, options = {})
          user = order.try(:user)
          return false if user.blank?

          event = user.bridesmaid_party_events.last
          event ||= user.bridesmaid_party_members.last.try(:event)

          return false if event.blank?

          #quantity = event.members.where("spree_user_id is not null").count
          quantity = event.bridesmaids_count.to_i
 
          quantity > preferred_count
        end
      end
    end
  end
end
