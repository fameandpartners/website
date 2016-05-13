class GuestCheckoutAssociation
  def self.associate_user_for_guest_checkout(spree_order:, spree_current_user:)
    return false if spree_current_user.present? || spree_order.billing_address.nil?
    u = Spree::User.where('email = :email AND first_name ILIKE :first_name AND last_name ILIKE :last_name', email: spree_order.billing_address.email.strip, first_name: spree_order.billing_address.firstname.strip, last_name: spree_order.billing_address.lastname.strip).first
    return false if u.nil?
    spree_order.user = u
    true
  end
end
