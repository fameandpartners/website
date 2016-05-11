class GuestCheckoutAssociation
  def self.associate_user_for_guest_checkout(spree_order:, spree_current_user:, user_address:)
    return false if spree_current_user.present?
    u = Spree::User.where('email = :email AND first_name ILIKE :first_name AND last_name ILIKE :last_name', email: user_address["bill_address_attributes"]["email"], first_name: user_address["bill_address_attributes"]["firstname"], last_name: user_address["bill_address_attributes"]["lastname"]).first
    return false if u.nil?
    spree_order.user = u
    true
  end
end
