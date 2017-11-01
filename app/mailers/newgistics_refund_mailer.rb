class NewgisticsRefundMailer < ActionMailer::Base
  default from: "from@example.com"
  def email(order, line_item)
    @order_numbers = order
    @line_item = line_item
    #Add text once copy is ready.
  end
end
