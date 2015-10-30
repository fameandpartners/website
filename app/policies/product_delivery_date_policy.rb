require 'business_time'

module Policies

  class ProjectDeliveryDatePolicy

    EXPRESS_MAKING    = {:days_for_making => 2, :days_for_delivery => 4}
    FAST_MAKING       = {:days_for_making => 5, :days_for_delivery => 4}
    STANDARD_DELIVERY = {:days_for_making => 7, :days_for_delivery => 4}
    SPECIAL_ORDER     = {:days_for_making => 9, :days_for_delivery => 4}

    PRINTED_MATCH   = /Print|Animal|Aztec|Baroque|Brocade|Check|Checkered|Conversational|Digital|Floral|Geometric|Gingham|Ikat|Leopard|Monochrome|Ombre|Paisley|Patchwork|Photographic|Plaid|Polka Dot|Psychedelic|Scarf|Spots|Stripes|Tie Dye|Tribal|Tropical|Victorian|Watercolour|Zebra/i
    BEADING_MATCH   = /Beading|Embellishment|Sequin/i
    EMBROIDER_MATCH = /Embroid/i

    attr_reader :order

    def initialize(product)
      @product = product
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
       beading? || printed? || embroidered?
    end

    def standard_delivery?
      !special_order? && !fast_making
    end

    def fast_making?
      @product.try(:fast_making) || @product.try(:making_options).any?{|mo| mo.name="Express Making"}
    end

    def delivery_date
      return FAST_MAKING if fast_making?
      return STANDARD_DELIVERY if standard_delivery?
      return SPECIAL_ORDER if special_order?
    end

    def self.order_delivery_date(user_cart)
      exist_express_making = user_cart.products.any?{ |p| p.making_options.any?{|mo| mo.name=='Express Making'}}
      all_express_making   = user_cart.products.all?{ |p| p.making_options.any?{|mo| mo.name=='Express Making'}}

      if all_express_making || !exist_express_making
        max = 0
        user_cart.products.each do |p|
          date_num = Policies::ProjectDeliveryDatePolicy.new(p).delivery_date
          date_num = date_num[:days_for_making] + date_num[:days_for_delivery] + configatron.days_delivery_emergency
          max = date_num if date_num > max
        end
        date = (Date.today + max).strftime("%d %B")
        return {date: date}
      end

      if exist_express_making
        max_express     = 0
        max_non_express = 0
        user_cart.products.each do |p|
          date_num = Policies::ProjectDeliveryDatePolicy.new(p).delivery_date
          date_num = date_num[:days_for_making] + date_num[:days_for_delivery] + configatron.days_delivery_emergency
          if p.making_options.any?{|mo| mo.name == 'Express Making'}
            max_express = date_num if date_num > max_express
          else
            max_non_express = date_num if date_num > max_non_express
          end
        end
        date_express     = (Date.today + max_express).strftime("%d %B")
        date_non_express = (Date.today + max_non_express).strftime("%d %B")
        return {date_express: date_express, date_non_express: date_non_express}
      end
    end

  end
end
