# A rule to apply to an order with line items greater than a specific count
module Spree
  class Promotion
    module Rules
      class ItemCount < PromotionRule
        preference :count, :integer

        attr_accessible :preferred_count

        def eligible?(order, options = {})
          order.line_items.sum(:quantity) > preferred_count
        end
      end
    end
  end
end
