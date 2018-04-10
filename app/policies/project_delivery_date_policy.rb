# TODO: 28th November 2016, marked for deletion
# This policy conflicts with `OrderProjectedDeliveryDatePolicy` and `LineItemProjectedDeliveryDatePolicy`
# Being unused, unreadable and unmaintainable

require 'business_time'

module Policies
  class ProjectDeliveryDatePolicy

    DAYS_FOR_DELIVERY = 4
    EXPRESS_MAKING    = {:days_for_making => 2, :days_for_delivery => DAYS_FOR_DELIVERY}
    FAST_MAKING       = {:days_for_making => 10, :days_for_delivery => DAYS_FOR_DELIVERY}
    SUPER_FAST_MAKING = {:days_for_making => 5, :days_for_delivery => DAYS_FOR_DELIVERY}
    SPECIAL_ORDER     = {:days_for_making => 10, :days_for_delivery => DAYS_FOR_DELIVERY}

    PRINTED_MATCH   = /Print|Animal|Aztec|Baroque|Brocade|Check|Checkered|Conversational|Digital|Floral|Geometric|Gingham|Ikat|Leopard|Monochrome|Ombre|Paisley|Patchwork|Photographic|Plaid|Polka Dot|Psychedelic|Scarf|Spots|Stripes|Tie Dye|Tribal|Tropical|Victorian|Watercolour|Zebra/i
    BEADING_MATCH   = /Beading|Embellishment|Sequin/i
    EMBROIDER_MATCH = /Embroid/i

    attr_reader :order

    def initialize(product, customized = false, making_options = nil)
      @product        = product
      @customized     = customized
      @making_options = making_options
    end

    def printed?
      @product.description =~ PRINTED_MATCH
    end

    def beading?
      @product.description =~ BEADING_MATCH
    end

    def embroidered?
      @product.description =~ EMBROIDER_MATCH
    end

    def special_order?
       !!(beading? || printed? || embroidered?)
    end

    def standard_delivery?
      !special_order? && !fast_making?
    end

    def fast_making?
      return false if @making_options == "standard"
      return true if @product.try(:fast_making)
      if @product.making_options.present?
        return true if @product.try(:making_options).any?{|mo| mo.name == "Express Making"}
      end
      return false
    end

    def super_fast_making?
      return false if @making_options == "standard"
      return true if @product.try(:super_fast_making)
      if @product.making_options.present?
        return true if @product.try(:making_options).any?{|mo| mo.name == "Really Express Making"}
      end
      return false
    end
    
    def delivery_date
      return FAST_MAKING if fast_making?
      return SUPER_FAST_MAKING if super_fast_making?
      if @product.standard_days_for_making.present? && @product.customised_days_for_making.present?
        return {days_for_making: @product.standard_days_for_making,   days_for_delivery: DAYS_FOR_DELIVERY} if !@customized
        return {days_for_making: @product.customised_days_for_making, days_for_delivery: DAYS_FOR_DELIVERY}
      end
      return SPECIAL_ORDER if special_order?
      return {days_for_making: @product.default_standard_days_for_making,   days_for_delivery: DAYS_FOR_DELIVERY} if !@customized
      return {days_for_making: @product.default_customised_days_for_making, days_for_delivery: DAYS_FOR_DELIVERY}
    end

    def self.delivery_date_text(delivery_date_obj)
      start_date = Date.today + delivery_date_obj[:days_for_making].to_i + configatron.days_delivery_emergency
      end_date   = start_date + DAYS_FOR_DELIVERY
      (start_date + 1).strftime("%d %b") + " and " + end_date.strftime("%d %b")
    end

    def self.order_delivery_date(user_cart)

      user_cart.products = user_cart.products.reject{ |p| p.name == "Gift" }
      exist_express_making = user_cart.products.any?{ |p| p.making_options.any?{|mo| mo.name == 'Express Making'}}
      all_express_making   = user_cart.products.all?{ |p| p.making_options.any?{|mo| mo.name == 'Express Making'}}

      if (all_express_making || !exist_express_making) && user_cart.products.size > 0
        max_start_date = 0
        dates_product_takes_longest = nil
        user_cart.products.each do |p|
          customized = p.customizations.size > 0
          date_num = Policies::ProjectDeliveryDatePolicy.new(p, customized).delivery_date
          if date_num[:days_for_making].to_i > max_start_date
            max_start_date = date_num[:days_for_making].to_i + configatron.days_delivery_emergency
            dates_product_takes_longest = date_num
          end
        end
        start_date = (Date.today + max_start_date + 1).strftime("%d %b")
        end_date   = (Date.today + max_start_date + dates_product_takes_longest[:days_for_delivery]).strftime("%d %b")
        return {start_date: start_date, end_date: end_date}
      end

      if exist_express_making
        max_start_date_express     = 0
        max_start_date_non_express = 0
        dates_express_product_takes_longest     = nil
        dates_non_express_product_takes_longest = nil
        user_cart.products.each do |p|
          customized = p.customizations.size > 0
          date_num = Policies::ProjectDeliveryDatePolicy.new(p, customized).delivery_date
          if p.making_options.any?{|mo| mo.name == 'Express Making'}
            if date_num[:days_for_making].to_i > max_start_date_express
              max_start_date_express = date_num[:days_for_making].to_i + configatron.days_delivery_emergency
              dates_express_product_takes_longest = date_num
            end
          else
            if date_num[:days_for_making].to_i > max_start_date_non_express
              max_start_date_non_express = date_num[:days_for_making].to_i + configatron.days_delivery_emergency
              dates_non_express_product_takes_longest = date_num
            end
          end
        end

        start_date_express     = (Date.today + max_start_date_express + 1).strftime("%d %b")
        end_date_express       = (Date.today + max_start_date_express + dates_express_product_takes_longest[:days_for_delivery].to_i).strftime("%d %b")
        start_date_non_express = (Date.today + max_start_date_non_express + 1).strftime("%d %b")
        end_date_non_express   = (Date.today + max_start_date_non_express + dates_non_express_product_takes_longest[:days_for_delivery].to_i).strftime("%d %b")

        return {start_date_express: start_date_express, end_date_express: end_date_express, start_date_non_express: start_date_non_express, end_date_non_express: end_date_non_express}
      end
    end

  end
end
