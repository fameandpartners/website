module Preferences
  class ShoppingBag < Base
    def free_styling_key
      "#{site_version.code}_free_styling_key"
    end

    def free_delivery_key
      "#{site_version.code}_free_delivery_key"
    end

    def customer_service_key
      "#{site_version.code}_customer_service_key"
    end

    def free_styling
      preference_value(free_styling_key)
    end

    def free_delivery
      preference_value(free_delivery_key)
    end

    def customer_service
      preference_value(customer_service_key)
    end
  end
end
