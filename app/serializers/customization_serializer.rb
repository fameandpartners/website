class CustomizationSerializer < ActiveModel::Serializer
    attributes :presentation, :name, :price, :display_price
    
    def presentation
        object['customisation_value']['presentation']
    end

    def name
        object['customisation_value']['name']
    end

    def price
        scope[:currency] == "AUD" ? BigDecimal.new(object['customisation_value']['price_aud'] || 0) * 100 : BigDecimal.new(object['customisation_value']['price'] || 0) * 100
    end

    def display_price
        666
    end
end