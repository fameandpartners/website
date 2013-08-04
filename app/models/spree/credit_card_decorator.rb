Spree::CreditCard.class_eval do
  attr_accessor :full_name
  attr_accessible :full_name
  attr_accessible :cc_type

  def full_name=(value)
    self.first_name, self.last_name = value.split(' ')
  end

  # remove expiration data validations
  _validators.reject!{ |key, value| [:month, :year].include?(key) }
  _validate_callbacks.each do |callback|
    callback.raw_filter.attributes.reject! { |key| [:month, :year].include?(key) } if callback.raw_filter.respond_to?(:attributes)
  end

  validates :cc_type,
            :inclusion => {
              :in => ActiveMerchant::Billing::CreditCardMethods::CARD_COMPANIES.keys
            }

  # don't store expiration data to db
  attr_accessor :month, :year

  def has_payment_profile?
    gateway_payment_profile_id.present?
  end

  # override method to avoid storing
  def set_last_digits
  end

  def display_number
    if last_digits.present?
      "XXXX-XXXX-XXXX-#{last_digits}"
    else
      "XXXX-XXXX-XXXX-XXXX"
    end
  end 
end
