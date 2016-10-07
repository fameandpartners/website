class GuestCheckoutAssociation
  def self.call(spree_order:)
    bill_address = spree_order.bill_address
    return false if bill_address.nil?
    if (spree_user = Spree::User.where('email = :email AND first_name ILIKE :first_name AND last_name ILIKE :last_name', email: bill_address.email.strip, first_name: bill_address.firstname.strip, last_name: bill_address.lastname.strip).first)
      spree_order.user = spree_user
      spree_order.save
    end
  end
end
