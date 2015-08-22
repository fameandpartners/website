Spree::Promotion.class_eval do
  attr_accessible :eligible_to_sale_order, :eligible_to_custom_order, :require_shipping_charge

  def eligible?(order)
    return false if expired? || usage_limit_exceeded?(order)

    return false if order.has_personalized_items? && !eligible_to_custom_order?

    return false if order.has_items_on_sale? && !eligible_to_sale_order?

    rules_are_eligible?(order, {})
  end

  class << self

    def find_by_code(code)
      self.where("lower(code) = ?", code.to_s.downcase).first
    end

  end

#  # is dead code?
#  def discount
#    @discount ||= begin
#      action = self.actions.find{|a| a.calculator_type == 'Spree::Calculator::FlatPercentItemTotal' }
#      amount = action.present?  ? action.calculator.preferred_flat_percent : BigDecimal.new(0)
#
#      OpenStruct.new(amount: amount, size: amount)
#    end
#  end

end
