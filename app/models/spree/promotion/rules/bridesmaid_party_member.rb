# A rule to apply to an order when user is bride or bridesmaid
module Spree
  class Promotion
    module Rules
      class BridesmaidPartyMember < PromotionRule
        def eligible?(order, options = {})
          user = order.try(:user)
          return false if user.blank?

          user.bridesmaid_party_events.present? || user.bridesmaid_party_members.present?
        end
      end
    end
  end
end
