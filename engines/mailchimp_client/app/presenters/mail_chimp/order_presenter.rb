module MailChimp
  class OrderPresenter

    attr_accessor :order

    def initialize(order)
      self.order = order
    end

    def to_h
      {
        id:            order.number,
        customer:      customer_for_order(order),
        currency_code: order.currency,
        order_total:   order.total.to_f,
        lines:         order_line_items(order)
      }
    end

    private

    def customer_for_order(order)
      if order.user
        UserPresenter.new(order.user).to_h
      else
        {
          id:            order.number,
          email_address: order.email,
          first_name:    order.user_first_name,
          last_name:     order.user_last_name,
          opt_in_status: false
        }
      end
    end

    def order_line_items(order)
      order.line_items.map { |line_item| LineItemPresenter.new(line_item).to_h }
    end
  end
end
