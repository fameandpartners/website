class ProductionOrderEmailService
  attr_reader :order

  def initialize(order_id)
    @order = Spree::Order.find(order_id)
  end


  def deliver
    order.line_items.group_by{ |i|i.factory }.each do |factory, items|
      Spree::OrderMailer.production_order_email(order, factory, items).deliver
    end    
  end
end
