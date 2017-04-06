module Policies
  module DeliveryPolicy
    CNY_DELIVERY_PERIOD = '2 weeks'
    FAST_MAKING_DELIVERY_PERIOD = '5 - 7 business days'
    SLOW_MAKING_DELIVERY_MAP = {  "7 - 10 business days" => "6 weeks", 
                                  "12 - 15 business days" => "6 weeks",
                                  "3 - 4 weeks" => "8 weeks",  
                                  "4 - 6 weeks" => "10 weeks" }
    CNY_DELIVERY_MAP = {  "7 - 10 business days" => "17 - 20 business days",
                          "12 - 15 business days" => "22 - 25 business days",
                          "3 - 4 weeks" => "5 - 6 weeks",
                          "4 - 6 weeks" => "6 - 8 weeks",
                          "6 weeks" => "8 weeks",
                          "10 weeks" => "12 weeks" }   

    # Max delivery period got from taxons
    def maximum_delivery_period
      return Spree::Taxon::DELIVERY_PERIODS.first unless @product.taxons.any?

      @product.taxons.inject(@product.taxons.first.delivery_period) do |max_period, taxon|
        current_major_value = period_in_business_days(taxon.delivery_period)
        max_major_value = period_in_business_days(max_period)

        current_major_value > max_major_value ? taxon.delivery_period : max_period
      end
    end

    # thanh - deprecating this useless thing
    # def cny_delivery_period
    #   CNY_DELIVERY_PERIOD
    # end

    def fast_making_delivery_period
      FAST_MAKING_DELIVERY_PERIOD
    end

    # take the maximum_delivery_period then map that to whatever tania says
    # if any new delivery range are introduced slow_mapper needs to be updated
    def slow_making_delivery_period     
      mdp = maximum_delivery_period

      if SLOW_MAKING_DELIVERY_MAP[mdp]
        SLOW_MAKING_DELIVERY_MAP[mdp]
      else
        "Delayed Shipping"  # using this catch all will raise a red flag and force an inquiry
      end
    end

    # adjusts for cny based on hard mappings
    def adjust_for_cny(period)
      if CNY_DELIVERY_MAP[period]
        CNY_DELIVERY_MAP[period]
      else
        "#{period} + #{CNY_DELIVERY_PERIOD}"  # bad case
      end
    end

    private


    def period_in_business_days(period)
      value = major_value_from_period(period)
      period_units(period) == 'weeks' ? value * 5 : value
    end

    # returns days/weeks from string
    def period_units(period)
      period.match(/(?<=\d\s)[\w\s]+$/).to_s
    end

    # returns the larger number from the range in given string
    def major_value_from_period(period)
      period.match(/\d+(?=\s+\w+|$)/).to_s.to_i
    end
  end
end
