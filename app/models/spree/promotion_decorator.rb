Spree::Promotion.class_eval do
  def eligible?(order)
    return false if expired? || usage_limit_exceeded?(order) || customisation_order(order)
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

  private

  def customisation_order(order)
    customisation = order.has_personalized_items?
    codes = %w(swm30 is20 who20 fam20 btb20p btb20d gf20 theparcel25)
    girlfriend = codes.include?(self.name.downcase)

    binding.pry
    
    if girlfriend || !customisation
      # allow promocode usage
      return false
    else
      # dont allow promocode usage
      return true
    end

  end


end
