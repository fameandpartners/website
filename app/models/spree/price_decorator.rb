Spree::Price.class_eval do
  def amount_without_discount
    self[:amount]
  end

  def amount_with_discount
    if current_sale.active?
      current_sale.apply(amount_without_discount)
    else
      amount_without_discount
    end
  end

  def display_amount_with_discount
    money_with_discount
  end

  alias :display_price_with_discount :display_amount_with_discount

  alias :display_amount_without_discount :display_amount
  alias :display_price_without_discount :display_amount_without_discount

  def money_with_discount
    Spree::Money.new(amount_with_discount || 0, { :currency => currency })
  end

  def with_discount?
    current_sale.active? && current_sale != 0
  end

  def final_amount
    with_discount? ? amount_with_discount : amount_without_discount
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

  private

  def current_sale
    @current_sale ||= Spree::Sale.first_or_initialize
  end
end
