module UserCart; end
class UserCart::CartPresenter < OpenStruct
  def serialize
    {
      products: products.map do |product|
        result = product.serialize
        result[:path] = ApplicationController.helpers.collection_product_path(product)
        result
      end,
      item_count: item_count,
      promocode: promocode,
      display_item_total: display_item_total.to_s,
      display_shipment_total: (display_shipment_total.present? ? display_shipment_total.to_s : 'Free Shipping'),
      display_promotion_total: display_promotion_total.to_s,
      display_total: display_total.to_s,
      masterpass_available: masterpass_available?,
      masterpass_is_production: !masterpass_payment_method.prefers_test_mode? && masterpass_payment_method.server_mode == Mastercard::Common::PRODUCTION
    }
  end

  def masterpass_payment_method
    @masterpass_payment_method ||= Spree::PaymentMethod.where(
        type: "Spree::Gateway::Masterpass",
        # environment: Rails.env,
        active: true,
        deleted_at: nil
    ).first
  end

  def masterpass_available?
    masterpass_payment_method.present?
  end
end
