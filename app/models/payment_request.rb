class PaymentRequest < ActiveRecord::Base
  ORDER_VALID_STATES = %w(cart address payment)

  belongs_to :order, class_name: 'Spree::Order'

  attr_accessible :message, :recipient_email, :recipient_full_name

  validates :order, :presence => true
  
  validates :recipient_email, :presence => true, :format => { :with => Devise.email_regexp }

  validates :recipient_full_name, :presence => true
  
  validates :message, :length => { :maximum => 2048 }

  validate :order_state_must_be_valid

  validate :user_must_be_present

  # validates :size, inclusion: { in: %w(small medium large), message: "%{value} is not a valid size" }

  before_create do
    self.token = SecureRandom.base64(72).tr('+/=', '-_ ').strip.delete("\n")
  end

  after_create do
    Spree::OrderMailer.guest_payment_request(self).deliver
    Spree::OrderMailer.delay_for(12.hours).guest_payment_request(self, true)
  end

  def order_state_must_be_valid
    unless ORDER_VALID_STATES.include?(order.state)
      errors.add(:order, 'is in invalid state')
    end 
  end

  def user_must_be_present
    unless order.reload.user.present?
      errors.add(:base, 'You should be registered user')
    end
  end

end
