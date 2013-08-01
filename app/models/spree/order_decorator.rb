Spree::Order.class_eval do
  checkout_flow do
    go_to_state :address
    go_to_state :payment, :if => lambda { |order|
      # Fix for #2191
      if order.shipping_method
        order.create_shipment!
        order.update_totals
      end
      order.payment_required?
    }
    go_to_state :confirm, :if => lambda { |order| order.confirmation_required? }
    go_to_state :complete, :if => lambda { |order| (order.payment_required? && order.has_unprocessed_payments?) || !order.payment_required? }
  end

  def confirmation_required?
    false
  end

  def first_name
    self.user_first_name.present? ? self.user_first_name : self.user.try(:first_name)
  end

  def last_name
    self.user_last_name.present? ? self.user_last_name : self.user.try(:last_name)
  end

  def full_name
    "#{first_name} #{last_name}".strip
  end
end
