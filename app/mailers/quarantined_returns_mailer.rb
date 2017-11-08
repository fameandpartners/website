class QuarantinedReturnsMailer < ActionMailer::Base
  default from: "from@example.com"

  def email(order, inventory_items)
    @order_numbers = order
  end
end
