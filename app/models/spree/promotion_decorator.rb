Spree::Promotion.class_eval do
  def eligible?(order)
    return false if expired? || usage_limit_exceeded?(order)

    return false if order.has_personalized_items? && !eligible_to_custom_order?

    return false if order.has_items_on_sale? && !eligible_to_sale_order?

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

  protected

    # rude method. possible, it should be thrown away
    def can_apply_to_any_order?
      %w(xtra10 swm30 is20 who20 fam20 btb20p btb20d gf20 theparcel25 frenzy5p crafted4u vosn2015).include?(self.code.downcase)
    end

  private

    # note - this methods should be set in db or somewhere else.
    #
    # Spree::Calculator::PersonalizationDiscount designed to hack orders with personalizations,
    # so it can pass
    def eligible_to_custom_order?
      calculators = self.actions.map{|action| action.calculator.try(:type) }.compact.uniq

      return true if calculators.include?('Spree::Calculator::PersonalizationDiscount')

      self.can_apply_to_any_order?
    end

    def eligible_to_sale_order?
      self.can_apply_to_any_order?
    end
end
