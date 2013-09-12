Spree::Variant.class_eval do
  delegate_belongs_to :default_price, :display_price, :display_amount, :price, :price=, :currency, :final_price, :price_without_discount if Spree::Price.table_exists?

  def in_sale?
    current_sale.active?
  end

  private

  def current_sale
    @current_sale ||= Spree::Sale.first_or_initialize
  end
end
