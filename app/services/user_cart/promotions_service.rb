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
require 'securerandom'
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

  def reapply
    apply_coupon_code
    order.reload
    apply_coupon_code
    order.reload
  end

  private

    def promotion
      @promotion ||= code.present? ? Spree::Promotion.find_by_code(code) : nil
    end

    def conflicting_coupon_exists?

      if @promotion.code == "DELIVERYDISC"
        return order.promotions.any? {|x| x.code == "DELIVERYINS"}
        
      elsif @promotion.code == "DELIVERYINS"
        return order.promotions.any? {|x| x.code == "DELIVERYDISC"}
      end

      return false
    end

    def delete_old_promotions
      order.adjustments.promotion.each do |promo| 
        promo.delete
      end
      order.adjustments.each do  |adj|
        if !adj.eligible
          order.adjustments.delete(adj)
          adj.delete
        end
      end
      order.save
    end


    def split_promotion
      old_promo = order.adjustments.promotion.eligible.first
      promo_code = old_promo.originator.promotion.code.split('DELIVERYDISC').first

      promo = Spree::Promotion.find_by_code(promo_code)
      delete_old_promotions
      old_promo.originator.promotion.destroy
      old_promo.destroy
      order.adjustment_total = 0
      order.save!
      order.reload
      promo.activate(:order => order, :coupon_code => promo.code)

    end

    def combine_promotion_with_return_discount(promo_amount1, promo_amount2, promo_code, promo_name)

      promo = Spree::Promotion.new
      guid = SecureRandom.uuid.to_s
      promo.name = "#{promo_name}DELIVERYDISC"
      promo.code = "#{promo_code}DELIVERYDISC#{guid}"
      promo.event_name = "spree.checkout.coupon_code_added"
      promo.usage_limit = 1
      promo.description = ""
      promo.advertise                = false
      promo.eligible_to_custom_order = true
      promo.eligible_to_sale_order   = false
      promo.save!

      calculator  = Spree::Calculator::FlatRate.create
      calculator.preferred_amount   = promo_amount1 + promo_amount2
      calculator.preferred_currency = 'USD'
      calculator.save!

      action = Spree::Promotion::Actions::CreateAdjustment.create
      action.calculator   = calculator
      action.activator_id = promo.id
      action.save!

      promo.actions << action
      promo.save!
      delete_old_promotions
      promo.activate(:order => order, :coupon_code => promo.code)

    end

    def update_promo_if_better(promo, old_promo)
      if (order.item_total * 0.1) + promo.amount.abs > old_promo.amount.abs
        combine_promotion_with_return_discount((order.item_total * 0.1), promo.amount.abs, promo.originator.promotion.code, promo.originator.promotion.name)
        old_promo.originator.promotion.destroy
        @message = I18n.t(:coupon_code_applied)
        true
      else
        order.adjustments.promotion.delete(promo)
        order.adjustments.delete(promo)
        order.save
        @message = I18n.t(:coupon_code_better_exists)
        false
      end
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

      if conflicting_coupon_exists?
        return false
      end

      # check if coupon code is already applied
      if order.adjustments.promotion.eligible.detect { |p| p.originator.promotion.code == promotion.code }.present?
        if promotion.code.downcase == 'deliverydisc'
          delivery_disc = order.adjustments.promotion.eligible.select{|p| p.originator.promotion.code == promotion.code}.first
          delivery_disc.delete
          return true
        end
        @message = I18n.t(:coupon_code_already_applied)
        return true
      end

      if order.adjustments.promotion.detect { |p| p.originator.promotion.code.include?(promotion.code)}.present? && promotion.code.downcase.include?('deliverydisc')
        #do splitting magic
        split_promotion
        return true
      end

      previous_promo = order.adjustments.promotion.eligible.first
      promotion.activate(:order => order, :coupon_code => promotion.code)
      promo = order.adjustments.promotion.detect { |p| p.originator.promotion.code == order.coupon_code }

      if previous_promo.present? and promo.present? and promo.originator.promotion.code == 'DELIVERYDISC' 
        combine_promotion_with_return_discount(promo.amount.abs,previous_promo.amount.abs, previous_promo.originator.promotion.code, previous_promo.originator.promotion.name)
        true
      elsif  previous_promo.present? and promo.present? and  previous_promo.originator.promotion.code == 'DELIVERYDISC'
        combine_promotion_with_return_discount(promo.amount.abs,previous_promo.amount.abs, promo.originator.promotion.code, promo.originator.promotion.name)
        true
      elsif previous_promo.present? and promo.present? and previous_promo.originator.promotion.code.include?('DELIVERYDISC')
        update_promo_if_better(promo, previous_promo)
      elsif  promo.present? and promo.eligible
        @message = I18n.t(:coupon_code_applied)
        true
      elsif order.coupon_code.downcase == 'deliveryins' && order.line_items.any? {|x| x.product.name.downcase == 'return_insurance'}
        @message = I18n.t(:coupon_code_applied)
        true
      elsif previous_promo.present? and promo.present?
        order.adjustments.promotion.delete(promo) #remove inferior prom
        order.adjustments.delete(promo)
        order.save
        @message = I18n.t(:coupon_code_better_exists)
        false
      elsif promo.present?
        order.adjustments.promotion.delete(promo) #remove ineligible promo
        order.adjustments.delete(promo)
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
