Spree::CreditCard.class_eval do
  attr_accessor :full_name
  attr_accessible :full_name

  def full_name=(value)
    self.first_name, self.last_name = value.split(' ')
  end

  # don't store expiration data to db
  attr_accessor :month, :year

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
