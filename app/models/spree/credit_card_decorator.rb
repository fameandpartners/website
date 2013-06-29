Spree::CreditCard.class_eval do
  attr_accessor :full_name
  attr_accessible :full_name

  def full_name=(value)
    self.first_name, self.last_name = value.split(' ')
  end
end
