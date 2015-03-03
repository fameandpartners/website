module UserCart; end
class UserCart::PromotionsService
  attr_reader :order, :code     # input
  attr_reader :status, :message # output

  def initialize(options = {})
    @order        = options[:order]
    @code         = options[:code]
  end

  def apply
    if apply_coupon_code
      @status = :ok
      true
    else
      @status = :error
      false
    end
  end

  private

    def promotion
      @promotion ||= Spree::Promotion.find_by_code(code)
    end

    def apply_coupon_code
      if promotion.blank?
        @message = I18n.t(:coupon_code_not_found)
        return false
      end

      if promotion.expired?
        @message = I18n.t(:coupon_code_expired)
        return false
      end

      if promotion.usage_limit_exceeded?
        @message = I18n.t(:coupon_code_max_usage)
        return false
      end

      order.update_attributes(coupon_code: promotion.code)

      # check if coupon code is already applied
      if order.adjustments.promotion.eligible.detect { |p| p.originator.promotion.code == promotion.code }.present?
        @message = I18n.t(:coupon_code_already_applied)
        return true
      end

      previous_promo = order.adjustments.promotion.eligible.first
      promotion.activate(:order => order, :coupon_code => promotion.code)
      promo = order.adjustments.promotion.detect { |p| p.originator.promotion.code == order.coupon_code }

      if promo.present? and promo.eligible
        @message = I18n.t(:coupon_code_applied)
        true
      elsif previous_promo.present? and promo.present?
        @message = I18n.t(:coupon_code_better_exists)
        false
      elsif promo.present?
        @message = I18n.t(:coupon_code_not_eligible)
        false
      else
        # if the promotion was created after the order
        @message = I18n.t(:coupon_code_not_found)
        false
      end
    end
end
