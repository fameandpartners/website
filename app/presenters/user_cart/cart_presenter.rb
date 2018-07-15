module UserCart; end
class UserCart::CartPresenter < OpenStruct
  def serialize
    {
      products: products.map do |product|
        result = product.serialize
        result[:path] =  Spree::LineItem.find(product.line_item_id).stock.nil? ? ApplicationController.helpers.collection_product_path(product) : ApplicationController.helpers.line_item_path(product.line_item_id)
        result
      end,
      site_version: site_version,
      order_number: order_number,
      item_count: item_count,
      promocode: promocode,
      display_item_total: display_item_total.to_s,
      display_item_total_cent: display_item_total.money.fractional,
      display_shipment_total: (display_shipment_total.present? ? display_shipment_total.to_s : 'Free Shipping'),
      display_shipment_total_cent: (display_shipment_total.present? ? display_shipment_total.money.fractional : 0),
      display_promotion_total: display_promotion_total.to_s,
      display_promotion_total_cent: display_promotion_total.money.fractional,
      display_total: display_total.to_s,
      display_total_cent: display_total.money.fractional,
      taxes: taxes,
      masterpass_available: masterpass_available?,
      masterpass_is_production: masterpass_is_production?,
      delivery_delay: Features.active?(:cny_delivery_delays),
      delivery_discount: "$#{('%.2f' %(display_item_total.money.fractional.to_f/1000).round(2)).to_s}"
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

  def masterpass_is_production?
    if masterpass_payment_method.present?
      !masterpass_payment_method.prefers_test_mode? && masterpass_payment_method.server_mode == Mastercard::Common::PRODUCTION
    end
  end

  def masterpass_available?
    if Features.active?(:masterpass)
      masterpass_payment_method.present?
    end
  end
end
