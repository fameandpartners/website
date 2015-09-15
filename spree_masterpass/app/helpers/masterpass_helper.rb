module MasterpassHelper
  def masterpass_payment_method
    @masterpass_payment_method ||= Spree::PaymentMethod.where(
        type: "Spree::Gateway::MasterPass",
        environment: Rails.env,
        active: true,
        deleted_at: nil
    ).first
  end

  def masterpass_available?
    masterpass_payment_method.present?
  end

  def masterpass_active?
    masterpass_available? && (Features.active?(:masterpass, current_spree_user) || session[:auto_applied_promo_code] == 'masterpass25')
  end
end