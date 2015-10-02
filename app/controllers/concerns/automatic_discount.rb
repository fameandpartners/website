  # If you provide an url param `faadc` (Fame Auto Apply Discount Code)
# on any page load, this controller concern will attempt to add the coupon
# specified in the param to the user's cart.
#
# It will also attempt to use the value stored in the session
# key `auto_apply_promo` to retry the application of the promo code
# throughout the session until it is successfully applied.
#
# e.g.
# `/lookbook/all-size?faadc=instafame20`
# would apply the promo code `instafame20` to the cart
#
# Note that the promo code *must* be able to be added to an empty order, so
# rules about minimum order size etc will usually just result in the promotion
# being marked as *not eligible*, with very little explanation.

module Concerns
  module AutomaticDiscount
    extend ActiveSupport::Concern

    included do
      before_filter :apply_automatic_discount_code
      helper_method :automatic_discount_code
    end

    private def auto_apply_discount_param_key
      :faadc
    end

    private def auto_apply_discount_retry_key
      :auto_apply_promo
    end

    private def skip_discount_code_reminder?
      params[:skip_reminder] == 'true'
    end

    #### ALERT ALERT WARNING
    # Marketing campaign 'forgot' to add the correct parameters to URLs
    # 2015-09-08
    # TTL 30 days
    def hack_masterpass_campaign!
      if request.url && request.url.include?("4w9UJiJpWAc")
        session[auto_apply_discount_retry_key] = "masterpass25"
      end
    end

    def automatic_discount_code
      @automatic_discount_code ||= begin
        if params[auto_apply_discount_param_key].present?
          session[auto_apply_discount_retry_key] = params[auto_apply_discount_param_key]
        end
        hack_masterpass_campaign!
        session[auto_apply_discount_retry_key]
      end
    end

    def apply_automatic_discount_code
      return :not_get_request  unless request.get?
      return :no_code_provided unless automatic_discount_code.present?
      return :already_on_order if current_order.promocode.to_s.downcase == automatic_discount_code.downcase

      promo_service = UserCart::PromotionsService.new(
        order: current_order,
        code:  automatic_discount_code.to_s
      )

      session[:email_reminder_promo] = 'scheduled_for_delivery' if skip_discount_code_reminder?

      # The promo code might not apply for a multitude of reasons, though
      # usually it's a rule (Spree::Promotion::Rules) on the promocode.
      #
      # If you want auto discount application to work on inbound marketing links,
      # ensure the promocode you are using can be applied to an empty cart.
      # A `Spree::Promotion::Rules::ItemTotal` rule might cause you grief.
      if promo_service.apply
        fire_event('spree.checkout.coupon_code_added')
        session.delete(auto_apply_discount_retry_key)
        session[:auto_applied_promo_code] = automatic_discount_code

        begin
          Marketing::CustomerIOEventTracker.new.track(
            current_spree_user,
            'auto apply modal',
            email:            current_order.email,
            code:             automatic_discount_code.to_s
          )
        rescue StandardError => e
          NewRelic::Agent.notice_error(e)
        end

      end

    rescue StandardError => e
      NewRelic::Agent.notice_error(e)
    end
  end
end
