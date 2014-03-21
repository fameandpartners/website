Spree::Promotion.class_eval do
  def eligible?(order)
    return false if expired? || usage_limit_exceeded?(order) || order.has_personalized_items?
    rules_are_eligible?(order, {})
  end

  # use it to raw 
  def calculate_price_with_discount(price)
    discount = 0.0
    self.actions.each do |action|
      case action.calculator_type
      when "Spree::Calculator::FlatRate"
        discount += action.calculator.compute(nil)
      when "Spree::Calculator::PerItem"
        discount += action.calculator.preferred_amount
      when "Spree::Calculator::FlatPercentItemTotal"
        # this calcultor requires an order
        value = price.amount * BigDecimal(action.calculator.preferred_flat_percent.to_s) / 100.0
        discount += (value * 100).round.to_f / 100 
      else
        # do nothing
      end
    end
    price.amount -= discount
    return price
  rescue
    price
  end
end
