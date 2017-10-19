class DamagedReturnsMailer < ActionMailer::Base
  default from: "from@example.com"
  def email(order, inventory_item)
    @order_numbers = order
    @inventory_items = inventory_item
    #Add text once copy is ready.
  end
end
