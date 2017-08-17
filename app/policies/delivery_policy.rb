module Policies
  module DeliveryPolicy
    DAYS_IN_FLIGHT = 5 # the number of days item takes for delivery(3 + 2 buffer days)
    DAYS_IN_FLIGHT_FAST = 3 # number of days for express delivery

    CNY_DELIVERY_PERIOD = '2 weeks'
    FAST_MAKING_DELIVERY_PERIOD = '4 - 6 business days'
    SLOW_MAKING_DELIVERY_PERIOD = "6 weeks"
    # SLOW_MAKING_DELIVERY_MAP = {  "7 - 10 business days" => "5 weeks",
    #                               "12 - 15 business days" => "5 weeks",
    #                               "3 - 4 weeks" => "5 weeks"
    #                            }
    FAST_MAKING_MAKE_TIME = "2 business days"
    SLOW_MAKING_MAKE_TIME = "5 weeks"
    STANDARD_MAKE_TIME_MAP = {
      "7 - 10 business days" => "5 business days",
      "12 - 15 business days" => "9 business days",
      "3 - 4 weeks" => "15 business days",
      "4 - 6 weeks" => "25 business days"
    }

    CNY_DELIVERY_MAP = {  "7 business days" => "17 - 20 business days",
                          "12 - 15 business days" => "22 - 25 business days",
                          "3 - 4 weeks" => "5 - 6 weeks",
                          "4 - 6 weeks" => "6 - 8 weeks"
                       }

    # Max delivery period got from taxons
    def maximum_delivery_period
      return Spree::Taxon::DELIVERY_PERIODS.first unless @product.taxons.any?

      @product.taxons.inject(@product.taxons.first.delivery_period) do |max_period, taxon|
        current_major_value = period_in_business_days(taxon.delivery_period)
        max_major_value = period_in_business_days(max_period)

        current_major_value > max_major_value ? taxon.delivery_period : max_period
      end
    end

    def fast_making_delivery_period
      FAST_MAKING_DELIVERY_PERIOD
    end

    def slow_making_delivery_period
      SLOW_MAKING_DELIVERY_PERIOD
    end

    # adjusts for cny based on hard mappings
    def adjust_for_cny(period)
      if CNY_DELIVERY_MAP[period]
        CNY_DELIVERY_MAP[period]
      else
        "#{period} + #{CNY_DELIVERY_PERIOD}"  # bad case
      end
    end

    # determine ship_by_date for product manufacturing consumption
    def ship_by_date(order_completed_at, delivery_period)
      value = minor_value_from_period(delivery_period) #take the smaller number, for more aggressive make times
      units = period_units(delivery_period)

      # special case for express
      if delivery_period == FAST_MAKING_DELIVERY_PERIOD
        return period_in_business_days(FAST_MAKING_MAKE_TIME).business_days.after(order_completed_at)
      end

      if delivery_period == SLOW_MAKING_DELIVERY_PERIOD
        return period_in_business_days(SLOW_MAKING_MAKE_TIME).business_days.after(order_completed_at)
      end

      if make_time = STANDARD_MAKE_TIME_MAP[delivery_period]
        return period_in_business_days(make_time).business_days.after(order_completed_at)
      end

      #this is no bueno case
      Raven.capture_exception("#{delivery_period} does not map.")
      raise Exception("Invalid delivery_period: #{delivery_period}")
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

    # returns small number
    def minor_value_from_period(period)
      period.match(/\d+/).to_s.to_i
    end
  end
end
