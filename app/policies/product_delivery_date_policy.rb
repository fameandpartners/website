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

  end
end
