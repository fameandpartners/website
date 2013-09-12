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

  private

  def current_sale
    @current_sale ||= Spree::Sale.first_or_initialize
  end
end
