class GuestCheckoutAssociation
  def self.associate_user_for_guest_checkout(order, spree_current_user, user_info)
    return false if spree_current_user.present?
    u = Spree::User.where('email = :email AND first_name ILIKE :first_name AND last_name ILIKE :last_name', email: user_info["bill_address_attributes"]["email"], first_name: user_info["bill_address_attributes"]["firstname"], last_name: user_info["bill_address_attributes"]["lastname"]).first
    return false if u.nil?
    order.user = u
    true
  end
end
