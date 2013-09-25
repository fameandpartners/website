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

  def sale_shipping_method
    Spree::ShippingMethod.find_by_name('sale_11_95')
  end

  def has_sale_shipping?
    sale_shipping_method.present? && shipments.exists?(shipping_method_id: sale_shipping_method.id)
  end

  def update!
    if sale_shipping_method.present? && ((shipping_method.nil? && Spree::Sale.any?) || has_sale_shipping?)
      update_totals

      if item_total < 100
        unless has_sale_shipping?
          self.shipping_method = sale_shipping_method
          create_shipment!
        end
      elsif has_sale_shipping?
        shipments.find_by_shipping_method_id(sale_shipping_method.id).try(:destroy)
      end
    end

    updater.update
  end

  def confirmation_required?
    false
  end

  has_one :payment_request

  def process_payments!
    begin
      pending_payments.each do |payment|
        break if payment_total >= total
        payment.process!

        if payment.completed?
          self.payment_total += payment.amount
        end
      end
    rescue Spree::Core::GatewayError => e
      result = !!Spree::Config[:allow_checkout_on_gateway_error]
      errors.add(:base, e.message) and return result
    end
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

  def deliver_order_confirmation_email
    begin
      Spree::OrderMailer.confirm_email(self.id).deliver
      Spree::OrderMailer.team_confirm_email(self.id).deliver
      log_product_purchased
    rescue Exception => e
      logger.error("#{e.class.name}: #{e.message}")
      logger.error(e.backtrace * "\n")
    end
  end

  def add_variant(variant, quantity = 1, currency = nil)
    current_item = find_line_item_by_variant(variant)
    if current_item
      current_item.quantity += quantity
      current_item.currency = currency unless currency.nil?
      current_item.save
    else
      current_item = Spree::LineItem.new(:quantity => quantity)
      current_item.variant = variant
      if currency
        current_item.currency    = currency unless currency.nil?
        current_item.price       = variant.price_in(currency).final_amount
        if variant.in_sale?
          current_item.old_price = variant.price_in(currency).amount_without_discount
        end
      else
        current_item.price       = variant.final_price
        if variant.in_sale?
          current_item.old_price = variant.price_without_discount
        end
      end
      self.line_items << current_item
    end

    self.reload
    current_item
  end

  def log_products_purchased
    line_items.each do |line_item|
      Activity.log_product_purchased(line_item.product, self.user, self)
    end
  end
end
