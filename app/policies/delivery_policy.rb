module Policies
  module DeliveryPolicy

    def display_period_for_making_option(from_date, making_option)
      return nil unless making_option

      if making_option.is_cny?(from_date)
        making_option.cny_delivery_period
      else
        making_option.delivery_period
      end
    end

    def delivery_date_for_making_option(from_date, making_option)
      return nil unless making_option

      if making_option.is_cny?(from_date)
        from_date.to_date + making_option.cny_delivery_time_days.days
      else
        from_date.to_date + making_option.delivery_time_days.days
      end
    end

    def ship_by_date_for_making_option(from_date, making_option)
      return nil unless making_option

      if making_option.is_cny?(from_date)
        making_option.cny_making_time_business_days.business_days.after(from_date.to_date)
      else
        making_option.making_time_business_days.business_days.after(from_date.to_date)
      end
    end
  end
end
