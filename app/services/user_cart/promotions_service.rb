# usage
#    service = UserCart::PromotionsService.new(
#      order: current_order,
#      code: params[:promotion_code]
#    )
#
#    if service.apply { true / false }
#    service.status   { :ok  / :error }
#    service.message  { translated text success/notice/error }
#
# note: some eligible/not eligible rules placed here
# app/models/spree/promotion_decorator.rb
# possible, we should extract logic from there
module UserCart
class PromotionsService
  attr_reader :order, :code     # input
  attr_reader :status, :message # output

  def initialize(order:, code:)
    @order        = order
    @code         = code.to_s.downcase
  end

  def apply
    if apply_coupon_code
      order.reload
      @status = :ok
      true
    else
      @status = :error
      false
    end
  end

  private

    def promotion
      @promotion ||= code.present? ? Spree::Promotion.find_by_code(code) : nil
    end

    def apply_coupon_code
      if order.nil?
        @message = I18n.t('spree.store.promotions.order_is_nil')
        return false
      end

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

      # NOTE: coupon_code - virtual attribute, calling update attributes for it useless
      # unless we have some tricky filters/callbacks
      #order.update_attributes(coupon_code: promotion.code)
      order.coupon_code = promotion.code # its working

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
        order.adjustments.promotion.delete(promo) #remove inferior promo
        order.save
        @message = I18n.t(:coupon_code_better_exists)
        false
      elsif promo.present?
        order.adjustments.promotion.delete(promo) #remove ineligible promo
        order.save
        @message = I18n.t(:coupon_code_not_eligible)
        false
      else
        # if the promotion was created after the order
        @message = I18n.t(:coupon_code_not_found)
        false
      end
    end
end
end
