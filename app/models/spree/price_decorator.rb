Spree::Price.class_eval do
  def apply(discount)
    return nil if (discount.nil? || discount.amount.to_i <= 0)
    amount_with_discount = self.amount * (100 - discount.size.to_i) / 100
    Spree::Price.new(amount: amount_with_discount, currency: self.currency)
  end

  def to_spree_price
    self
  end

  # if new currency == old, return self
  # if old currency == default, convert directly
  # if old currency != default, use cross-course
  # NOTE: price exchange rates stored in site version, and relative to default currency
  def convert_to(new_currency)
    return self if new_currency.blank? || self.currency == new_currency

    rate = SiteVersion.get_exchange_rate(currency, new_currency)
    if rate.present? 
      Spree::Price.new(amount: self.amount ? self.amount * rate : nil, currency: new_currency)
    else
      self
    end
  end
=begin
  def amount_without_discount
    self[:amount]
  end

  def amount_with_discount(surryhills = false)
    if current_sale.active?
      current_sale.apply(amount_without_discount, surryhills)
    else
      amount_without_discount
    end
  end

  def display_amount_with_discount(surryhills = false)
    money_with_discount(surryhills)
  end

  alias :display_price_with_discount :display_amount_with_discount

  alias :display_amount_without_discount :display_amount
  alias :display_price_without_discount :display_amount_without_discount

  def money_with_discount(surryhills = false)
    Spree::Money.new(amount_with_discount(surryhills) || 0, { :currency => currency })
  end

  def with_discount?
    current_sale.active? && current_sale != 0
  end

  def final_amount(surryhills = false)
    with_discount? ? amount_with_discount(surryhills) : amount_without_discount
  end

  private

  def current_sale
    @current_sale ||= Spree::Sale.first_or_initialize
  end
=end
end
