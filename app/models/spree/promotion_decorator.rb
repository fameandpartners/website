Spree::Promotion.class_eval do
  def eligible?(order)
    return false if expired? || usage_limit_exceeded?(order) || order.has_personalized_items?
    rules_are_eligible?(order, {})
  end
end
