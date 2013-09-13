class PaymentRequest < ActiveRecord::Base
  ORDER_VALID_STATES = %w(address payment)

  belongs_to :order,
             class_name: 'Spree::Order'

  attr_accessible :message,
                  :recipient_email,
                  :recipient_full_name

  validates :recipient_email,
            presence: true,
            format: {
              allow_blank: true,
              with: Devise.email_regexp
            }
  validates :recipient_full_name,
            presence: true
  validates :message,
            length: {
              maximum: 2048
            }
  validate do
    if PaymentRequest.exists?(order_id: order_id)
      errors.add(:base, 'Already sent for this order')
    end
  end
  validate do
    unless ORDER_VALID_STATES.include?(order.state)
      errors.add(:order, 'is in invalid state')
    end
  end

  before_create do
    self.token = SecureRandom.base64(72).tr('+/=', '-_ ').strip.delete("\n")
  end

  after_create do
    Spree::OrderMailer.guest_payment_request(self).deliver
  end
end
