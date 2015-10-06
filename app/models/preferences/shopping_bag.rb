module Preferences
  class ShoppingBag < Base
    def value_proposition_key
      "#{site_version.code}_value_proposition_key"
    end

    def value_proposition
      preference_value(value_proposition_key)
    end

    def shipping_message_key
      "#{site_version.code}_shipping_message_key"
    end

    def shipping_message
      preference_value(shipping_message_key)
    end
  end
end
