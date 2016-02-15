class RefundRequest < ActiveRecord::Base
  belongs_to :order, class_name: 'Spree::Order'
  belongs_to :payment, class_name: 'Spree::Payment'
  validates_presence_of :payment_ref
  validates_uniqueness_of :payment_ref

  attr_accessible :payment,
                  :order,
                  :order_number,
                  :payment_ref,
                  :currency,
                  :payment_amount,
                  :acceptance_status,
                  :requested_refund_amount,
                  :payment_created_at,
                  :customer_name,
                  :customer_email,
                  :refund_ref,
                  :refund_currency,
                  :refund_success,
                  :refund_amount,
                  :refund_created_at,
                  :refund_error_message,
                  :refund_status_message,
                  :public_key,
                  :secret_key,
                  :api_url

  def pin?
    payment_ref.to_s.starts_with? 'ch'
  end

  def set_from_charge(charge)
    self.customer_name      ||= charge.card.try(:name)
    self.customer_email     = charge.email
    self.payment_ref        = charge.token
    self.payment_amount     = charge.amount
    self.currency           = charge.currency
    self.payment_created_at = charge.created_at
    self
  end

  def set_refund(refund)
    self.refund_ref            = refund.token
    self.refund_amount         = refund.amount
    self.refund_currency       = refund.currency
    self.refund_created_at     = refund.created_at
    self.refund_status_message = refund.status
    self
  end

  def refundable?
    valid? &&
      public_key.present? &&
      secret_key.present? &&
      ! refund_ref.present?
  end

  def refund!
    return :unrefundable_request unless refundable?

    set_pin_config

    if (charge = PinPayment::Charge.find(self.payment_ref))
      refund = if charge.refunds.present?
        charge.refunds.first
      else
        charge.refund!
      end

      self.set_refund(refund)
    end
  end

  def refresh_refund_status
    set_pin_config

    if (charge = PinPayment::Charge.find(self.payment_ref))
      if refund = charge.refunds.first
        self.set_refund(refund)
      end
    end
  end


  def set_spree_relations
    if payment = Spree::Payment.where(response_code: payment_ref).first
      self.payment      = payment
      self.order        = payment.order
      self.order_number = payment.order.number
    end
  end

  def set_pin_config
    PinPayment.api_url    = self.api_url
    PinPayment.public_key = self.public_key
    PinPayment.secret_key = self.secret_key
  end
end

PinPayment::Charge.send(:include, PinRefunds::ChargeFindRefunds)
