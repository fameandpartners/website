module AdminUi
  module ItemReturnsHelper
    PRICE_ATTRIBUTES = %w(order_paid_amount item_price item_price_adjusted).freeze

    def formatted_attributes(attributes)
      attrs = attributes.clone

      PRICE_ATTRIBUTES.each { |attribute| attrs[attribute] = attrs[attribute].to_f / 100 if attrs.has_key?(attribute) }

      attrs
    end
  end
end
